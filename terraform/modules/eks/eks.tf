# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "aws" {
  region = var.aws_region
}

# Filter out local zones, which are not currently supported 
# with managed node groups
data "aws_availability_zones" "available" {
  count = var.create_module ? 1 : 0
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

locals {
  cluster_name    = "t2project-eks-${var.create_module ? random_string.suffix[0].result : ""}"
  cluster_version = 1.29
  count           = var.create_module ? 1 : 0
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  count   = var.create_module ? 1 : 0
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.5"
  count   = var.create_module ? 1 : 0

  name = local.cluster_name

  cidr = "10.0.0.0/16"
  azs  = slice(data.aws_availability_zones.available[0].names, 0, 3)

  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = 1
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.2"
  count   = var.create_module ? 1 : 0

  cluster_name    = local.cluster_name
  cluster_version = local.cluster_version

  vpc_id                         = module.vpc[0].vpc_id
  subnet_ids                     = module.vpc[0].private_subnets
  cluster_endpoint_public_access = true

  create_cloudwatch_log_group = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"

  }

  eks_managed_node_groups = {
    name = "ng-1"

    instance_types = ["t3.small"]
    # capacity_type  = "SPOT"

    min_size     = 1
    max_size     = 10
    desired_size = 3

  }
}

resource "null_resource" "merge_kubeconfig" {
  count = var.create_module && var.set_kubecfg ? 1 : 0

  depends_on = [aws_eks_addon.ebs-csi, null_resource.aws_cli_check]

  provisioner "local-exec" {
    command = "aws eks --region ${var.aws_region} update-kubeconfig --name ${local.cluster_name}"
  }
}

resource "null_resource" "aws_cli_check" {
  count = var.create_module && var.set_kubecfg ? 1 : 0

  provisioner "local-exec" {
    command    = "which aws"
    on_failure = fail
  }
}

# https://aws.amazon.com/blogs/containers/amazon-ebs-csi-driver-is-now-generally-available-in-amazon-eks-add-ons/ 
data "aws_iam_policy" "ebs_csi_policy" {
  arn   = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  count = var.create_module ? 1 : 0
}

module "irsa-ebs-csi" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "~> 5.34"
  count   = var.create_module ? 1 : 0

  create_role                   = true
  role_name                     = "AmazonEKSTFEBSCSIRole-${module.eks[0].cluster_name}"
  provider_url                  = module.eks[0].oidc_provider
  role_policy_arns              = [data.aws_iam_policy.ebs_csi_policy[0].arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
}

resource "aws_eks_addon" "ebs-csi" {
  cluster_name             = module.eks[0].cluster_name
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = "v1.27.0-eksbuild.1"
  service_account_role_arn = module.irsa-ebs-csi[0].iam_role_arn
  count                    = var.create_module ? 1 : 0

  tags = {
    "eks_addon" = "ebs-csi"
    "terraform" = "true"
  }
}

module "lb_role" {
  count  = var.create_module && var.create_lb ? 1 : 0
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name                              = "${var.env_name}_eks_lb"
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks[0].oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}

resource "kubernetes_service_account" "service-account" {
  count = var.create_module && var.create_lb ? 1 : 0
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/name"      = "aws-load-balancer-controller"
      "app.kubernetes.io/component" = "controller"
    }
    annotations = {
      "eks.amazonaws.com/role-arn"               = module.lb_role.iam_role_arn
      "eks.amazonaws.com/sts-regional-endpoints" = "true"
    }
  }
}

resource "helm_release" "alb-controller" {
  count      = var.create_module && var.create_lb ? 1 : 0
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  depends_on = [
    kubernetes_service_account.service-account
  ]

  set {
    name  = "region"
    value = var.aws_region
  }

  set {
    name  = "vpcId"
    value = module.vpc[0].vpc_id
  }

  set {
    name  = "image.repository"
    value = "602401143452.dkr.ecr.${var.aws_region}.amazonaws.com/amazon/aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "clusterName"
    value = local.cluster_name
  }
}
