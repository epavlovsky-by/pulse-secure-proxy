#!/bin/sh

SCRIPT_DIR=$(dirname "$0")

# If docker image does not exist - building it
if [ -z "$(docker image ls | grep pulse-secure-proxy)" ]; then
    echo 'Docker image does not exist - building it'
    /bin/sh $SCRIPT_DIR/build.sh
fi

docker run -it --rm --privileged \
    -p 8888:8888 \
    pulse-secure-proxy