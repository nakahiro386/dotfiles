#!/usr/bin/env bash
set -e

cd $(dirname $0)
sudo ./bin/mitamae.sh local $@ install_anyenv.rb --node-yaml=node.yaml
