# Terraform

This folder contains the files to deploy the T2-Project with [Terraform](https://www.terraform.io/) for different target environments: local (kind), AWS (EKS) and Azure (AKS).

[kind](https://kind.sigs.k8s.io/) is a tool for running local Kubernetes clusters using Docker container "nodes".
[Amazon Elastic Kubernetes Service](https://aws.amazon.com/de/eks/) (EKS) is the managed Kubernetes offering by AWS.
[Azure Kubernetes Service](https://learn.microsoft.com/en-us/azure/aks/) (AKS) is the managed Kubernetes offering by Azure.

## Quick Start

*For illustration purposes, AWS is used here as the target environment, but can easily be replaced with Azure or kind.*

1. Take a look into the file `environments/aws/main.tf` to check if your desired modules are enabled/disabled.
2. Login to AWS in your terminal.
3. Run the start script: `./aws-start.sh`
4. Get yourself a cup of tea, make yourself comfortable and wait for around 20 minutes
5. Check if everything works:
   - `kubectl cluster-info`
   - `kubectl get pods`

If you don't need the cluster anymore, stop everything and delete the cluster: `./aws-stop.sh`

## Folder Structure

[Isolation via file layout](https://blog.gruntwork.io/how-to-manage-terraform-state-28f5697e68fa#a921) is used to separate the different environments and state files from each other:

- [environments/aws](./environments/aws/)
- [environments/azure](./environments/azure/)
- [environments/kind](./environments/kind/)

To execute a terraform command you have to specify which environment you want to use.

Example using aws environment:

```sh
terraform -chdir=./environments/aws/ init  -upgrade
```

If you are using the scripts provided in this folder (see section [Scripts](#scripts) below), the correct environment directory is used automatically.

## Terraform Providers

Terraform requires that providers know their configuration during plan time.
However, the providers `kubernetes`, `helm` and `kubectl` know how to connect to the cluster after it was created by Terraform.

Therefore, we have to ensure that the cluster is created as a separate `apply`-step to prevent any errors. For that we are using the Terraform apply parameter `-target` in the start scripts.

Example:

```sh
terraform -chdir=./environments/aws/ apply -target="module.eks" -auto-approve
```

For more information see:
- [Stacking with managed Kubernetes cluster resources – Terraform Docs](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs#stacking-with-managed-kubernetes-cluster-resources)
- [How to make Terraform provider dependent on a resource being created – Stack Overflow](https://stackoverflow.com/a/69996957/9556565)

## Modules

To see which modules are used when executing `terraform apply` take a look into the file `main.tf` for your target environment (e.g. `environments/aws/main.tf`).
To disable a module you don't need, e.g. Kepler, comment out the respective module in the file `main.tf`.

## Scripts

For each environment there are a start and a stop script, e.g. `aws-start.sh` and `aws-stop.sh`. The start script creates a cluster in the respective environment and installs everything required to run the T2-Project. The stop script deletes all resources and the cluster.

Optionally you can provide an argument to the scripts that is used as the namespace for the T2-Project. For example, `./aws-start.sh t2-project` will deploy the services of the T2-Project in the namespace *t2-project*.

The scripts are using the terraform apply parameter `-auto-approve`. Please be aware of that!

There is another script called `run.sh` that can be used to execute arbitrary terraform commands for a specific environment in a simplified way.

Example:

```sh
./run.sh aws init -upgrade
```

## Rigorous Clean-up

The stop scripts executes `terraform destroy` that deletes the most resources. However, typically, it leaves some resources. If you want to delete all AWS resources associated with your account in a specific region, you can use [cloud-nuke](https://github.com/gruntwork-io/cloud-nuke). This is a highly destructive operation! Please be aware of that!

Run the script:

```sh
./aws-nuke.sh
```
