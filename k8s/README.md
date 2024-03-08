# Kubernetes

This directory contains the Kubernetes related files to deploy the T2-Project in different variants.

For more information read the [https://t2-documentation.readthedocs.io/en/latest/microservices/deploy.html](T2-Project Deployment) documentation.

## Directory structure

| directory / file | content |
| ---------------- | ------- |
| [kubernetes-dashboard/](./kubernetes-dashboard/) | K8s manifests for Kubernetes dashboard |
| [load-balancer/](./load-balancer/) | K8s manifests for load balancing |
| [mongodb/](./mongodb/) | Helm values for MongoDB |
| [saga-e2e-test/](./saga-e2e-test/) | K8s manifests for the e2e test scenario |
| [t2-microservices/base/](./t2-microservices/) | K8s manifests for microservices |
| [t2-microservices/autoscaling/](./t2-microservices/autoscaling/) | Enable auto-scaling for t2-microservices |
| [t2-microservices/computation-simulation/](./t2-microservices/computation-simulation/) | Add optional intensive computation simulator |
| [t2-modulith/base/](./t2-modulith/) | K8s manifests for t2-modulith |
| [t2-modulith/autoscaling/](./t2-modulith/autoscaling/) | Enable auto-scaling for t2-modulith backend |
| [start-microservices.sh](./start-microservices.sh) | Script to deploy t2-microservices |
| [start-modulith.sh](./start-modulith.sh) | Script to deploy t2-modulith |
| [start-saga-e2e-test.sh](./start-saga-e2e-test.sh) | Script to install everything needed for the saga e2e test |
| [stop-saga-e2e-test.sh](./stop-saga-e2e-test.sh) | Script to uninstall everything needed for the saga e2e test |
| [stop-microservices.sh](./stop-microservices.sh) | Script to uninstall t2-microservices |
| [stop-modulith.sh](./stop-modulith.sh) | Script to uninstall t2-modulith |
| [update-microservices.sh](./update-microservices.sh) | Script to update the already deployed t2-microservices |
| [update-modulith.sh](./update-modulith.sh) | Script to update the already deployed t2-modulith |
