# DevOps

This repository includes all the files that are relevant to deploy, test and operate the T2-Project, for both variants, T2-Microservices and T2-Modulith.

For more information read the [documentation](https://t2-documentation.readthedocs.io/en/latest/).

## Directory structure

| directory / file | content |
| ---------------- | ------- |
| [docker/](./docker/) | docker compose files for the T2-Project |
| [eksctl/](./eksctl/) | files to deploy the T2-Project to the AWS Cloud with eksctl |
| [energy-tests/](./energy-tests/) | config files for execute energy tests |
| [k8s/](./k8s/) | Kubernetes deployment files for the T2-Project |
| [loadprofiles/](./loadprofiles/) | load profiles for the Apache JMeter load generator |
| [prometheus/](./prometheus/) | config / rules / alerts for Prometheus |
| [terraform/](./terraform/) | files to deploy the T2-Project to different environments with Terraform |
| [setenv.sh](./setenv.sh) | export environment variables required do build the T2-Project locally |
