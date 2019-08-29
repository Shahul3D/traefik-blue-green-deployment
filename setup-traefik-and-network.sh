#!/bin/sh

NETWORK_NAME="$1"

if [ -z "$NETWORK_NAME" ]
then
    NETWORK_NAME="traefik_network"
fi
    export NETWORK_NAME="$NETWORK_NAME"

if [ -z $(docker network ls --filter "name=$NETWORK_NAME" --format "{{.Name}}") ]
then
    docker network create "$NETWORK_NAME"
fi

docker-compose -f docker-compose.traefik.yml up -d --force-recreate --remove-orphans
