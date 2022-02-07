#!/bin/sh

SCRIPT_DIR=$(dirname "$0")

# If docker image with same name (probably previous version) exists -cleaning it up
if [ ! -z "$(docker image ls | grep pulse-secure-proxy)" ]; then
    echo 'Docker image with same name exists - removing it'
    docker image rm pulse-secure-proxy
fi

docker build -t pulse-secure-proxy $SCRIPT_DIR/src