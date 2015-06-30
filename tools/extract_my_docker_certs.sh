#!/bin/bash
set -e
# TODO: fail gracefully

mkdir -p "$DOCKER_CERT_PATH"
vagrant ssh -c "cat /home/docker/.docker/ca.pem" > "$DOCKER_CERT_PATH/ca.pem"
vagrant ssh -c "cat /home/docker/.docker/cert.pem" > "$DOCKER_CERT_PATH/cert.pem"
vagrant ssh -c "cat /home/docker/.docker/key.pem" > "$DOCKER_CERT_PATH/key.pem"
