# Kubernetes

This directory contains the Kubernetes related files to deploy the T2-Project in different variants.

For more information read the [https://t2-documentation.readthedocs.io/en/latest/microservices/deploy.html](T2-Project Deployment) documentation.

## Directory structure

| directory / file | content |
| ---------------- | ------- |
| [./autoscaling/](./autoscaling/) | enable auto-scaling |
| [./computation-simulation/](./computation-simulation/) | optional deployment files for a computation simulator |
| [./kubernetes-dashboard/](./kubernetes-dashboard/) | Kubernetes dashboard |
| [./grafana-dashboards/](./grafana-dashboards/) | files for Grafana |
| [./kepler/](./kepler/) | deployment files for Kepler |
| [./saga-e2e-test/](./saga-e2e-test/) | deployment files for the e2e test scenario |
| [./start.sh](./start.sh) | install kubernetes deployments, including required helm charts |
| [./stop.sh](./stop.sh) | uninstall kubernetes deployments, including the helm charts |
| [./start-saga-e2e-test.sh](./start-saga-e2e-test.sh) | install everything needed for the saga e2e test |
| [./stop-saga-e2e-test.sh](./stop-saga-e2e-test.sh) | uninstall everything needed for the saga e2e test |
| [./update.sh](./update.sh) | update kubernetes deployments, including the helm charts |