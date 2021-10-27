#!/usr/bin/env bash

TEMP_DIR=".temp"
mkdir -p $TEMP_DIR
export VAULT_ADDR='http://127.0.0.1:8200'

if [ ! -f $TEMP_DIR/vault-init.json ]; then
     vault operator init --format json -n 1 -t 1 > $TEMP_DIR/vault-init.json
fi
cat $TEMP_DIR/vault-init.json| jq '.unseal_keys_hex[]'| xargs vault operator unseal
ROOT_TOKEN=`cat $TEMP_DIR/vault-init.json|jq '.root_token'`
sed "s/{{VAULT_TOKEN}}/${ROOT_TOKEN}/g" templates/vault-provider.json.template > $TEMP_DIR/vault-provider.json
consul acl bootstrap --format json | jq -r '.SecretID' > $TEMP_DIR/acl-token
export CONSUL_HTTP_TOKEN=`cat $TEMP_DIR/acl-token`
echo $CONSUL_HTTP_TOKEN
consul connect ca set-config  -config-file $TEMP_DIR/vault-provider.json
