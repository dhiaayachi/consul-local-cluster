This project is meant to run a consul local cluster with the most common features:
- connect (with vault ca provider)
- encryption
- intention
- ACL
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
The root ACL token will be printed at the end of the cluster boot.


to stop the cluster run:
```
./cluster-down
```