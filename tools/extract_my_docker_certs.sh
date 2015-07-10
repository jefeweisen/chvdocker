#!/bin/bash
pushd $(dirname "$0") > /dev/null
cd ..
adirRepo=$(pwd)
popd > /dev/null

set -e
# TODO: fail gracefully

. "$adirRepo/tools/env.sh"
echo "DOCKER_CERT_PATH = $DOCKER_CERT_PATH"
mkdir -p "$DOCKER_CERT_PATH"
vagrant ssh -c "cat /home/docker/.docker/ca.pem" > "$DOCKER_CERT_PATH/ca.pem"
vagrant ssh -c "cat /home/docker/.docker/cert.pem" > "$DOCKER_CERT_PATH/cert.pem"
vagrant ssh -c "cat /home/docker/.docker/key.pem" > "$DOCKER_CERT_PATH/key.pem"
