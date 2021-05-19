# kube
a somewhat working kubernetes set up for the t2 store, including the messaging, the databases and the cdc.

## Directory structure
| directory / file  | content |
| ----------------- | ------- |
| [./cdc/](cdc)     | deployment  | 
| [./db/](db)       | kube files for the databases |
| [./kafka/](kafka)          | kube files for the message broker | 
| [./notsaga/](notsaga)        | kube files for the T2 services that are not part of the saga |  
| [./saga/](saga)           | kube files for the T2 services that participate in the saga |   
| [./testsetup/](testsetup)     | kube files for the e2e test service and kube files for ui backend and payment in test mode |
| [./loadprofiles/](loadprofiles)   | load profiles for the Apache jMeter load generator |   
| [./prometheusfiles/](prometheusfiles)| config / rules / alerts for prometheus |   
| [./setenv.sh](setenv.sh)       | export environment variables required do build the T2 store locally |

## kafka
The T2 Store uses Kafka (with Zookeeper) as message broker.
The kube file is a mesh up of these tutorials:
* https://kubernetes.io/docs/tutorials/stateful-application/zookeeper/
* https://kubernetes.io/blog/2017/09/kubernetes-statefulsets-daemonsets/
    
The tutorials seem to be a bit outdated and the example is missing a service and the readiness probe is broken. 
However they are still very helpful.

### Services

The kube files define three services for the message broker:

* **kafka-hs** : a headless service for the Kafka. The kafka listens to port 9093. (Which was kind of confusing at first, but i guess the person who wrote the tutorials had their reasons.)
* **zk-hs** : headless service for the zookeeper. 
* **zk-cs** : cluster service for the zookeeper. Other services use this service to talk to the zookeeper.


## db  
The T2 store needs a postgres database for the cdc service and mongoDB databases for the domain data.

The deployment for the mongoDB is loosely based on this tutorial: https://kubernetes.io/blog/2017/01/running-mongodb-on-kubernetes-with-statefulsets/

I took hints on where to plug the storage into the postgres database from this tutorial: https://www.bmc.com/blogs/kubernetes-postgresql/
(I ignored the rest though and did it like with the mongoDB.)

## cdc  
The [eventuate tram CDC service](https://eventuate.io/docs/manual/eventuate-tram/latest/getting-started-eventuate-tram.html).

It requires the postgres database and the message broker to be up.

The kube file for the CDC service is derived from this docker-compose file: https://github.com/eventuate-tram/eventuate-tram-sagas-examples-customers-and-orders/blob/master/docker-compose-postgres.yml

## saga  
The T2 Stores saga participants. 
They require the message broker, the databases and the CDC service to work properly.
The Payment Service also requires a the payment provider.

### Services
- **orchestrator-cs** : cluster service such that other services can talk to the Orchestrator.
- **inventory-cs** : cluster service such that other services can talk to the Inventory.


## notsaga  
The T2 Store services that are not part of the saga.

The Cart Service requires the mondoDB database and the UI Backend requires the Orchestrator, Inventory and Cart Service to work properly.

### Services
*  provider-cs : cluster service to talk to the payment provider.
*  uibackend-cs : cluster service to talk to the ui backend.
*  ui-cs : cluster service to talk to the ui.

### Ingress
exists such that you can talk to the UI Backend from outside of _the cluster_.


## utility
Kube files for Pods that are useful for debugging.
They are not part of the T2 Store.
- **dnsutils** : what the title says 
    - usage (and source) : https://kubernetes.io/docs/tasks/administer-cluster/dns-debugging-resolution/)
- **pod-test** : kafka commandline consumer / producer to check kafka
    - usage : https://kafka.apache.org/quickstart (a bit outdated. but that's okey because the commondline guys provide help themselves)
    - source : https://imti.co/kafka-kubernetes/setting-up-kafka-on-kubernetes (rest of that post sucks though)