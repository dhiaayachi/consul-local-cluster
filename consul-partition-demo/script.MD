# DEMO script

## Intro, show the diagram of the setup

## Show the config / scipts

## start the demo script

## create partitions:
```bash
./create-partition.sh
consul admin-partition list
consul namespace list --partition team-bar
consul namespace list --partition team-foo
```
## create services:
```bash
docker exec -it consul-client1 consul services register --partition team-foo --namespace ns1 /tmp/service.json
docker exec -it consul-client2 consul services register --partition team-foo --namespace ns1 /tmp/service.json
docker exec -it consul-client2 consul services register --partition team-bar --namespace ns1 /tmp/service.json
./service-install.sh
curl -s "http://127.0.0.1:9003/Dhia"
 curl -s "http://127.0.0.1:9002/"
```

## show nodes:

### Catalog

```bash
consul catalog nodes
consul catalog nodes --partition team-foo
consul catalog nodes --partition team-bar
```

### health

```bash
curl -s "http://127.0.0.1:8500/v1/health/node/consul-client?partition=team-foo&ns=ns1" | jq .
curl -s "http://127.0.0.1:8500/v1/health/node/consul-client?partition=team-bar&ns=ns1" | jq .
```

## show services:

### Catalog

```bash
consul catalog services
consul catalog services --partition team-foo --namespace ns1
consul catalog services --partition team-bar --namespace ns1
```

### health

```bash
curl -s "http://127.0.0.1:8500/v1/health/service/web?partition=team-foo&ns=ns1" | jq '.[].Checks[1]'
curl -s "http://127.0.0.1:8500/v1/health/service/web?partition=team-bar&ns=ns1" | jq '.[].Checks[0]'
```
