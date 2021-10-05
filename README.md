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

#### Running a dev build of consul in the containers
<details>
  <summary>Click to expand!</summary>
  
* Build the appropriate binary with `GOOS=linux make dev` (or whatever OS version your underlying image is based upon)
* Replace the `consul` binary by attaching a volume directive like `/path_to_your_built_consul/consul:/bin/consul`

Example `docker-compose.yml`:

```json
services:
...
  consul-server1:
    image: consul:latest
    container_name: consul-server1
    restart: always
    volumes:
     - ./config/server1.json:/consul/config/server1.json:ro
     - ./certs/:/consul/config/certs/:ro
     - /path_to_your_built_consul/consul:/bin/consul
...
```

</details>
