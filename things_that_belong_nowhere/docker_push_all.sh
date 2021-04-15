# !bin/bash
version='v0.1.0'
registry='stiesssh'

docker push $registry/inventory:$version
docker push $registry/orchestrator:$version 
docker push $registry/payment:$version
docker push $registry/cart:$version
docker push $registry/uibackend:$version 
docker push $registry/order:$version 
docker push $registry/provider:$version 
