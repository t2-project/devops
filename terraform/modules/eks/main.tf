# Mainly based upon the example "eks_managed_node_group" provided by the module "terraform-aws-eks":
# https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/examples/eks_managed_node_group/main.tf

data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}

locals {
  cluster_name = "${var.cluster_name_prefix}-${random_string.suffix.result}"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = {
    Environment = "aws"
    Terraform   = "true"
  }
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.2"

  cluster_name                   = local.cluster_name
  cluster_version                = var.cluster_version
  cluster_endpoint_public_access = true

  # Add the current caller identity as an administrator
  enable_cluster_creator_admin_permissions = true

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
    aws-ebs-csi-driver = {
      service_account_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.cluster_name}-ebs-csi-controller"
      most_recent              = true
    }
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets

  eks_managed_node_groups = {

    # We use Bottlerocket, because Kepler needs support for cgroup v2, which neither Amazon Linux 2 nor Ubuntu 20.04 LTS have.
    node-group-1 = {
      platform       = "bottlerocket"
      ami_type       = "BOTTLEROCKET_x86_64"
      instance_types = ["c5.large"]

      # Not required nor used - avoid tagging two security groups with same tag as well
      create_security_group = false

      min_size     = 1
      max_size     = 10
      desired_size = 6

      block_device_mappings = {
        xvdb = {
          device_name = "/dev/xvdb"
          ebs = {
            volume_size           = 10
            volume_type           = "gp3"
            throughput            = 150
            delete_on_termination = true
          }
        }
      }
    }
  }

  tags = local.tags
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.5"

  name = local.cluster_name
  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 48)]
  intra_subnets   = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 52)]

  enable_nat_gateway     = true
  single_nat_gateway     = true
  enable_ipv6            = true
  create_egress_only_igw = true

  public_subnet_ipv6_prefixes                    = [0, 1, 2]
  public_subnet_assign_ipv6_address_on_creation  = true
  private_subnet_ipv6_prefixes                   = [3, 4, 5]
  private_subnet_assign_ipv6_address_on_creation = true
  intra_subnet_ipv6_prefixes                     = [6, 7, 8]
  intra_subnet_assign_ipv6_address_on_creation   = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  tags = local.tags
}

data "aws_iam_policy" "ebs_csi_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

# Source: https://stackoverflow.com/a/75377798/9556565
module "ebs_csi_controller_role" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "~> 5.35"
  create_role                   = true
  role_name                     = "${module.eks.cluster_name}-ebs-csi-controller"
  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = [data.aws_iam_policy.ebs_csi_policy.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
}

# Source: https://stackoverflow.com/a/66158811/9556565
resource "null_resource" "merge_kubeconfig" {
  count = var.set_kubecfg ? 1 : 0

  triggers = {
    cluster_updated = module.eks.cluster_id
  }

  # Wait until EKS cluster is ready. Also check if aws CLI exists.
  depends_on = [module.eks, null_resource.aws_cli_check]

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOT
      set -e
      echo 'Applying Auth ConfigMap with kubectl...'
      aws eks wait cluster-active --name '${module.eks.cluster_name}'
      aws eks update-kubeconfig --name '${module.eks.cluster_name}' --alias '${module.eks.cluster_name}-${var.region}' --region ${var.region}
    EOT
  }
}

resource "null_resource" "aws_cli_check" {
  count = var.set_kubecfg ? 1 : 0

  provisioner "local-exec" {
    command    = "which aws"
    on_failure = fail
  }
}
