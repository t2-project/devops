#!/bin/bash

MY_DIR="$(dirname "$(readlink -f "$0")")"
EKSCTL_DIR=$(builtin cd $MY_DIR/eksctl; pwd)
K8S_DIR=$(builtin cd $MY_DIR/../k8s; pwd)

# Ensure that you are logged-in
if ! aws sts get-caller-identity &> /dev/null
then
  echo "You have to login first!"
  exit 1
fi

# Setup EKS Cluster
echo "Creating AWS EKS cluster"
eksctl create cluster --config-file $EKSCTL_DIR/eks-cluster-config-basic.yaml

retVal=$?
if [ $retVal -ne 0 ]; then
    exit 1 # Creating of cluster failed
fi

# Install T2-Project
echo -e "\nInstalling T2-Project"
source $K8S_DIR/start.sh

# Optional: Install Prometheus
echo -e "\nInstalling Prometheus Stack"
source $K8S_DIR/start-prometheus.sh

# Optional: Install AWS Load Balancer & make desired services publically available
echo -e "\nInstalling AWS Load Balancer"
source $EKSCTL_DIR/install-aws-load-balancer.sh
sleep 10 # is required because the AWS load balancer webhook is not available immediately
#kubectl apply -f $EKSCTL_DIR/aws-loadbalancer-ui.yaml
kubectl apply -f $EKSCTL_DIR/aws-loadbalancer-grafana.yaml
GRAFANA_HOSTNAME=$(kubectl -n monitoring get svc prometheus-grafana-nlb -o jsonpath='{.status.loadBalancer.ingress[*].hostname}')
echo -e "\nGrafana URL: http://${GRAFANA_HOSTNAME}"
