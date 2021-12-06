#!/usr/bin/env bash


TEMP_DIR=".temp"
mkdir -p $TEMP_DIR

export VAULT_ADDR=http://127.0.0.1:8200
vault operator init --format json -n 1 -t 1 > $TEMP_DIR/vault-init.json
cat $TEMP_DIR/vault-init.json| jq '.unseal_keys_hex[]'| xargs vault operator unseal
ROOT_TOKEN=`cat $TEMP_DIR/vault-init.json|jq '.root_token'`
sed "s/{{VAULT_TOKEN}}/${ROOT_TOKEN}/g" templates/vault-provider-dc1.json.template > $TEMP_DIR/vault-provider-dc1.json
consul connect ca set-config  -config-file $TEMP_DIR/vault-provider-dc1.json


#export CONSUL_HTTP_ADDR=127.0.0.1:8501
#export VAULT_ADDR=http://127.0.0.1:8201
#vault operator init --format json -n 1 -t 1 > $TEMP_DIR/vault-init.json
#cat $TEMP_DIR/vault-init.json| jq '.unseal_keys_hex[]'| xargs vault operator unseal
#ROOT_TOKEN=`cat $TEMP_DIR/vault-init.json|jq '.root_token'`
#sed "s/{{VAULT_TOKEN}}/${ROOT_TOKEN}/g" templates/vault-provider-dc2.json.template > $TEMP_DIR/vault-provider-dc2.json
#consul connect ca set-config  -config-file $TEMP_DIR/vault-provider-dc2.json
#unset CONSUL_HTTP_ADDR