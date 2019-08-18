#!/bin/sh

SERVICE_NAME="$1"
REPLICAS_NUMBER="$2"
NETWORK_NAME="$3"

COMPOSE_PROJECT_NAME=$(echo $SERVICE_NAME | sed -e 's/-//g')

if [ -z "$REPLICAS_NUMBER" ] || [ "$REPLICAS_NUMBER" -lt "1" ]
then
    REPLICAS_NUMBER=1
fi

if [ -z "$NETWORK_NAME" ]
then
    NETWORK_NAME="traefik_network"
    export NETWORK_NAME="$NETWORK_NAME"
fi

ENV="blue"
OLD=""

if [ $(docker ps -f "name=${COMPOSE_PROJECT_NAME}${ENV}" --format "{{.Names}}" | wc -l) -eq "0" ]
then
    ENV=blue
    OLD=green
else
    ENV=green
    OLD=blue
fi

echo "Starting new $ENV environment\n"

docker-compose --project-name "${COMPOSE_PROJECT_NAME}${ENV}" up -d "$SERVICE_NAME"

echo "\nScaling new $ENV environment\n"

docker-compose --project-name "${COMPOSE_PROJECT_NAME}${ENV}" scale "$SERVICE_NAME"="$REPLICAS_NUMBER"

if [ $(docker ps -f "name=${COMPOSE_PROJECT_NAME}${OLD}" --format "{{.Names}}" | wc -l) -gt "0" ]
then
    docker-compose --project-name "${COMPOSE_PROJECT_NAME}${OLD}" scale "$SERVICE_NAME"=1

    echo "\nSwap from $OLD to $ENV containers\n"
    sleep 2

    docker-compose --project-name "${COMPOSE_PROJECT_NAME}${OLD}" stop "$SERVICE_NAME"

    echo "\nSwaping from $OLD to $ENV finished"
fi
