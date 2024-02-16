# Terraform

This folder contains the files to deploy the T2-Project with [Terraform](https://www.terraform.io/) for different environments: local (kind), AWS (EKS) and Azure (AKS).

Terraform is a infrastructure as code tool that uses a declarative approach.

## AWS

You can use the script `aws-start.sh` to create a EKS cluster in the AWS cloud with Terraform and install everything required to run the T2-Project and `aws-stop.sh` to delete everything again.

## Azure

You can use the script `azure-start.sh` to create a AKS cluster in the Azure cloud and install everything required to run the T2-Project and `azure-stop.sh` to delete everything again.
