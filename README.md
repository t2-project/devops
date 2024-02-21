# DevOps

This repository includes all the files that are relevant to deploy and test the T2-Project microservices.

For more information read the [https://t2-documentation.readthedocs.io/en/latest/](documentation).

## Directory structure

| directory / file | content |
| ---------------- | ------- |
| [./docker/](./docker/) | docker compose files for the T2-Project |
| [./eksctl/](./eksctl/) | files to deploy the T2-Project to the AWS Cloud with eksctl |
| [./energy-tests/](./energy-tests/) | config files for execute energy tests |
| [./k8s/](./k8s/) | Kubernetes deployment files for the T2-Project |
| [./loadprofiles/](./loadprofiles/) | load profiles for the Apache jMeter load generator |
| [./prometheus/](./prometheus/) | config / rules / alerts for Prometheus |
| [./setenv.sh](./setenv.sh) | export environment variables required do build the T2-Project locally |
| [./terraform/](./terraform/) | files to deploy the T2-Project to different environments with Terraform |
