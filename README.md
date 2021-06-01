# kube
Kubernetes deployments for the t2 store, the databases and the cdc.

## Directory structure
| directory / file  | content |
| ----------------- | ------- |
| [./cdc/](cdc)     | deployment for cdc service and its database | 
| [./notsaga/](notsaga)        | kube files for the T2 services that are not part of the saga |  
| [./saga/](saga)           | kube files for the T2 services that participate in the saga |   
| [./testsetup/](testsetup)     | kube files for the e2e test service and kube files for ui backend and payment in test mode |
| [./loadprofiles/](loadprofiles)   | load profiles for the Apache jMeter load generator |   
| [./prometheusfiles/](prometheusfiles)| config / rules / alerts for prometheus |   
| [./setenv.sh](setenv.sh)       | export environment variables required do build the T2 store locally |

## cdc  
The [eventuate tram CDC service](https://eventuate.io/docs/manual/eventuate-tram/latest/getting-started-eventuate-tram.html) and its database.
It requires the message broker to be up.

The database uses the [image provided by eventuateio](https://hub.docker.com/r/eventuateio/eventuate-tram-sagas-postgres), because that database all ready has the required tables and schemas. 

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
*  **provider-cs** : cluster service to talk to the payment provider.
*  **uibackend-cs** : cluster service to talk to the ui backend.
*  **ui-cs** : cluster service to talk to the ui.

### Ingress
exists such that you can talk to the UI Backend from outside of _the cluster_.