#!/bin/sh

SCRIPT_DIR=$(dirname "$0")

# If docker image does not exist - building it
if [ -z "$(docker image ls | grep pulse-secure-proxy)" ]; then
    echo 'Docker image does not exist - building it'
    /bin/sh $SCRIPT_DIR/build.sh
fi

HTTP_PROXY_PORT=$(cat $SCRIPT_DIR/.env | grep HTTP_PROXY_PORT | cut -d= -f2)

docker run -it --rm --privileged \
    --env-file=$SCRIPT_DIR/.env \
    -p $HTTP_PROXY_PORT:8888 \
    pulse-proxy-saml