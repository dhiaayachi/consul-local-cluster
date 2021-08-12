#!/usr/bin/env bash


TEMP_DIR=".temp"
mkdir -p $TEMP_DIR

export VAULT_ADDR=http://127.0.0.1:8200
vault operator init --format json -n 1 -t 1 > $TEMP_DIR/vault-init.json
cat $TEMP_DIR/vault-init.json| jq '.unseal_keys_hex[]'| xargs vault operator unseal
ROOT_TOKEN=`cat $TEMP_DIR/vault-init.json|jq '.root_token'`
sed "s/{{VAULT_TOKEN}}/${ROOT_TOKEN}/g" templates/vault-provider-dc1.json.template > $TEMP_DIR/vault-provider-dc1.json
consul acl bootstrap --format json | jq -r '.SecretID' > $TEMP_DIR/acl-token
export CONSUL_HTTP_TOKEN=`cat $TEMP_DIR/acl-token`
export ACL_TOKEN=`cat $TEMP_DIR/acl-token`
echo $CONSUL_HTTP_TOKEN
consul connect ca set-config  -config-file $TEMP_DIR/vault-provider-dc1.json
consul acl policy create -name replication -rules @templates/acl-policy.hcl
consul acl policy create -name agent-policy -rules @templates/agent-policy.hcl
consul acl token create -description "replication token" -policy-name replication -format json | jq -r '.SecretID' > $TEMP_DIR/acl-replication-token
consul acl token create -description "consul agent token" -policy-name agent-policy -format json | jq -r '.SecretID' > $TEMP_DIR/acl-agent-token


export CONSUL_HTTP_ADDR=127.0.0.1:8501
export VAULT_ADDR=http://127.0.0.1:8201
vault operator init --format json -n 1 -t 1 > $TEMP_DIR/vault-init.json
cat $TEMP_DIR/vault-init.json| jq '.unseal_keys_hex[]'| xargs vault operator unseal
ROOT_TOKEN=`cat $TEMP_DIR/vault-init.json|jq '.root_token'`
sed "s/{{VAULT_TOKEN}}/${ROOT_TOKEN}/g" templates/vault-provider-dc2.json.template > $TEMP_DIR/vault-provider-dc2.json
export CONSUL_HTTP_TOKEN=`cat $TEMP_DIR/acl-token`
echo $CONSUL_HTTP_TOKEN
consul connect ca set-config  -config-file $TEMP_DIR/vault-provider-dc2.json
unset CONSUL_HTTP_ADDR
export ACL_REPLICATION_TOKEN=`cat $TEMP_DIR/acl-replication-token`

for ID in {1..3}
do
docker exec -e "CONSUL_HTTP_TOKEN=$CONSUL_HTTP_TOKEN" -e "ACL_REPLICATION_TOKEN=$ACL_REPLICATION_TOKEN" -it dc2-consul-server$ID consul acl set-agent-token replication $ACL_REPLICATION_TOKEN
done