This project is meant to run a consul local cluster with the most common features:
- connect (with vault ca provider)
- encryption
- intention
- UI
- simple counting application (with 2 services)

Dependencies:
- docker
- docker-compose
- jq

to start the cluster run :

```
./cluster-up   
```


to stop the cluster run:
```
./cluster-down
```