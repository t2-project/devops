# kube
a somewhat working kubernetes set up for the t2 store, including the messaging, the databases and the cdc.

## kafka  
the kafka and its zookeeper.
a meshup of those tutorials:
* https://kubernetes.io/docs/tutorials/stateful-application/zookeeper/
* https://kubernetes.io/blog/2017/09/kubernetes-statefulsets-daemonsets/
    
however they seem a bit outdated. 
also the example is missing a service and the readiness probe is broken. 
still better than any other tutorial out there :)

### service
* kafka-hs : headless service for the kafka. kafka (currently) listens to 9093. (which was kind of confusing at first, but i guess who ever wrote the example had their reasons.)
* zk-hs : headless service for the zookeeper 
* zk-cs : not se headless service for zookeeper. this is where other services talk to the zookeeper. (i don't know why though :x)


## db  
the postgress db for the cdc and the mongo db for the domain data.

mongo is loosely based on this tutorial: https://kubernetes.io/blog/2017/01/running-mongodb-on-kubernetes-with-statefulsets/

took hints on where to plug the storgae for the postgress db in from this tutorial: https://www.bmc.com/blogs/kubernetes-postgresql/
i ignored the rest though and did it like with the mongo db.

## cdc  
the cdc from eventuate tram (https://eventuate.io/docs/manual/eventuate-tram/latest/getting-started-eventuate-tram.html)

requires a db and a mom.

current setup uses postgress db and kafka (+ zookeeper), like this: https://github.com/eventuate-tram/eventuate-tram-sagas-examples-customers-and-orders/blob/master/docker-compose-postgres.yml (but in kubernetes)


## saga  
the saga participants. only work if messaging, dbs and cdc are running.

### orchestrator 
- orchestrator-ext : LoadBalancer service because i wanted to talk to orchestrator.
- orchestrator-cs : normal (cluster?) service because other services (uibackend) want to talk to orchestrator, too.

### payment and order
- the have a service each, but i don't know wether they acutally need them.

### inventory 
- inventory-ext : LoadBalancer service because i wanted to talk to inventory (check whether db is populated as i want it)
- inventory-cs : normal service because other services (uibackend) want to talk to inventory, too.


## notsaga  
services that are not part of the saga. 
(they are not that important, you can also talk directly to the orchstrator.)

### cart
requires the mongo db
### uibackend
requires the inventory, the cart and the orchestrator.



## utility
pods that are useful for debugging.
- dnsutils : what the title says 
    - usage (and source) : https://kubernetes.io/docs/tasks/administer-cluster/dns-debugging-resolution/)
- pod-test/pod-test2 : kafka commandline consumer / producer to check kafka
    - usage : https://kafka.apache.org/quickstart (a bit outdated. but that's oke because the commondline guys provide help themselves)
    - source : https://imti.co/kafka-kubernetes/setting-up-kafka-on-kubernetes (rest of that post sucks though)

## TODO : a graph because i like graphs and they are mostly helpful. 

