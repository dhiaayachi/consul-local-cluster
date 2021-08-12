#!/usr/bin/env bash

TEMP_DIR=".temp"
CURRENT_DIR=`pwd`
rm -rf $TEMP_DIR/certs
mkdir -p $TEMP_DIR/certs
cd $TEMP_DIR/certs
consul tls ca create

mkdir dc1
cd dc1
cp ../consul-agent-ca* .
consul tls cert create -server -dc dc1 -additional-dnsname=dc2
cd ..

mkdir dc2
cd dc2
cp ../consul-agent-ca* .
consul tls cert create -server -dc dc2

cd $CURRENT_DIR