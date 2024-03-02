# eksctl

This folder contains the files to deploy the T2-Project to EKS (Amazon's managed Kubernetes service), using [eksctl](https://eksctl.io/).

eksctl is a CLI tool for creating and managing EKS clusters. In the background it uses CloudFormation for it.

To use Terraform instead, see folder [../terraform/](../terraform/).
In our experience Terraform works better, so we recommend to use Terraform.

The scripts `eksctl-start.sh` and `eksctl-stop.sh` are doing the same but using eksctl for it.
