#!/bin/bash
# usage:
#
# . ./env.sh

C="$HOME/.docker/boot2docker"

errecho () {
    echo "$1" 1>&2
}

# set environment:
export DOCKER_HOST=tcp://127.0.0.1:2376
export DOCKER_CERT_PATH="$C"
export DOCKER_TLS_VERIFY=1



