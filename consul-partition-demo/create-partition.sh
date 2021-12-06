#!/usr/bin/env bash

consul admin-partition  create -name team-foo
consul admin-partition  create -name team-bar
consul namespace create -name ns1 --partition team-foo
consul namespace create -name ns1 --partition team-bar