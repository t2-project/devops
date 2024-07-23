#!/bin/bash
TAG=local

dir="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"

cd $dir/../../microservices

docker build -t t2project/cart:$TAG -f cart/Dockerfile cart
docker build -t t2project/creditinstitute:$TAG -f creditinstitute/Dockerfile creditinstitute
docker build -t t2project/inventory:$TAG -f inventory/Dockerfile inventory
docker build -t t2project/orchestrator:$TAG -f orchestrator/Dockerfile orchestrator
docker build -t t2project/order:$TAG -f order/Dockerfile order
docker build -t t2project/payment:$TAG -f payment/Dockerfile payment
docker build -t t2project/ui:$TAG -f ui/Dockerfile ui
docker build -t t2project/uibackend:$TAG -f uibackend/Dockerfile uibackend

docker build -t t2project/e2etest:$TAG -f e2e-tests/Dockerfile e2e-tests
