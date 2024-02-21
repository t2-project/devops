#!/bin/bash

# Exit immediately if a command returns an error code
set -e

MY_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
K8S_DIR=$(builtin cd $MY_DIR/../k8s; pwd)

# Ensure that you are logged-in already!

CLUSTER_NAME=t2-project-eks-basic
REGION=eu-north-1
K8S_VERSION=1.28
NUMBER_OF_NODES=1

# Setup Kubernetes Cluster
eksctl create cluster --name ${CLUSTER_NAME} --region ${REGION} --version ${K8S_VERSION} --nodes=${NUMBER_OF_NODES}

# Enable IAM OIDC provider (required for storage)
eksctl utils associate-iam-oidc-provider --region=${REGION} --cluster=${CLUSTER_NAME} --approve

# Create Amazon EBS CSI driver IAM role (required for storage)
eksctl create iamserviceaccount \
  --name ebs-csi-controller-sa \
  --namespace kube-system \
  --cluster ${CLUSTER_NAME} \
  --role-name AmazonEKS_EBS_CSI_DriverRole \
  --role-only \
  --attach-policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy \
  --approve

# Add the Amazon EBS CSI add-on (required for storage)
eksctl create addon --name aws-ebs-csi-driver --cluster ${CLUSTER_NAME} --service-account-role-arn arn:aws:iam::$(aws sts get-caller-identity --query Account --output text):role/AmazonEKS_EBS_CSI_DriverRole --force

# Enable CloudWatch Observability
eksctl create iamserviceaccount \
  --name cloudwatch-agent \
  --namespace amazon-cloudwatch \
  --cluster "${CLUSTER_NAME}" \
  --role-name CloudWatch_Agent_Server_Policy \
  --role-only \
  --attach-policy-arn arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy \
  --attach-policy-arn arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess \
  --approve

eksctl create addon --name amazon-cloudwatch-observability --cluster ${CLUSTER_NAME} --service-account-role-arn arn:aws:iam::$(aws sts get-caller-identity --query Account --output text):role/CloudWatch_Agent_Server_Policy

# Install T2-Project
source $K8S_DIR/start.sh
