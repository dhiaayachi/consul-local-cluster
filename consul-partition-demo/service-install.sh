#!/usr/bin/env bash

TEMP_DIR=".temp"

###
# Container 1
###
# Download sample data layer service, Counting service
docker cp ./main consul-client1:/tmp/hello

docker exec consul-client1 chmod +x /tmp/hello
# Start Counting service as background process in container
docker exec -d consul-client1 /tmp/hello &
sleep 1s

###
# Container 2
###

# Download sample data layer service, Dashboard service
docker exec -d consul-client2 wget https://github.com/hashicorp/demo-consul-101/releases/download/0.0.3.1/counting-service_linux_amd64.zip
sleep 7s
# Unzip Counting service
docker exec -d consul-client2 unzip counting-service_linux_amd64.zip
sleep 7s
# Start Dashboard service as background process in container
docker exec -d consul-client2 ./counting-service_linux_amd64 &
sleep 1s

