# kube
a somewhat working kubernetes set up for the t2 store, including the messaging, the databases and the cdc.

## kafka  
the kafka and its zookeeper. 
a meshup of those tutorials: 

TODO : describe who is who

## db  
the postgress db for the cdc and the mongo db for the domain data.

mongo is based on this tutorial: 

postgress kind of as well.

## cdc  
the cdc from eventuate tram (link website)

required postgress db, messaging


## saga  
the saga participants. only work if messaging, dbs and cdc are running.


## notsaga  
the cart, which requires the mongo db, and the uibackend, which requires the inventory, the cart and the orchestrator.

i should but some fail safe like... if one of them is missing don't fail :x

## utility
pods that are useful for debugging
- dnsutils : what the title says
- pod-test/pod-test2 : kafka commandline consumer / producer to check kafka

### TODO dependency graph: 

