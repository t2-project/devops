# !bin/bash
version='v0.1.0'
registry='stiesssh'

docker build -t $registry/inventory:$version ./inventory/
docker build -t $registry/orchestrator:$version ./orchestrator/
docker build -t $registry/payment:$version ./payment/
docker build -t $registry/cart:$version ./cart/
docker build -t $registry/uibackend:$version ./uibackend/
docker build -t $registry/order:$version ./order/
docker build -t $registry/provider:$version ./paymentprovider/
