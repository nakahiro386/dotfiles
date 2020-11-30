#!/usr/bin/env bash
set -e

cd $(dirname $0)
./bin/mitamae.sh local $@ recipe.rb
