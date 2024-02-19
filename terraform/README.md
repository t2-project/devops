# Terraform

This folder contains the files to deploy the T2-Project with [Terraform](https://www.terraform.io/) for different target environments: local (kind), AWS (EKS) and Azure (AKS). Terraform is a infrastructure as code tool that uses a declarative approach.

Directories are used to separate the different environments and state files:

- [environments/aws](./environments/aws/)
- [environments/azure](./environments/azure/)
- [environments/kind](./environments/kind/)

If you are using the scripts (see below), the correct directory is used automatically.

The script are using the terraform apply parameter `-auto-approve`. Please be aware of that!

## kind

[kind](https://kind.sigs.k8s.io/) is a tool for running local Kubernetes clusters using Docker container "nodes".

You can use the script `kind-start.sh` to create a cluster with kind and install everything required to run the T2-Project. Use `kind-stop.sh` to delete everything again.

## AWS

[Amazon Elastic Kubernetes Service](https://aws.amazon.com/de/eks/) (EKS) is the managed Kubernetes offering by AWS.

You can use the script `aws-start.sh` to create a EKS cluster in the AWS cloud and install everything required to run the T2-Project. Use `aws-stop.sh` to delete everything again.

## Azure

[Azure Kubernetes Service](https://learn.microsoft.com/en-us/azure/aks/) (AKS) is the managed Kubernetes offering by Azure.

You can use the script `azure-start.sh` to create a AKS cluster in the Azure cloud and install everything required to run the T2-Project. Use `azure-stop.sh` to delete everything again.
