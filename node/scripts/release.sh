#!/bin/bash

state=$(docker inspect lnode | jq ".[0] .State .Running")
[ $state = true ] || (echo "container is not running" && exit 1)
# RELEASE del server in esecuzione
RELEASE=$(docker-compose exec -T lnode cat /etc/livenet/release | cut -d'=' -f2)
[ -n "$RELEASE" ] || exit 1
logger "current RELEASE: $RELEASE"
MINOR=$(echo $RELEASE | cut -d'.' -f2 )
digits=${#MINOR}
MAJOR=$(echo $RELEASE | cut -d'.' -f1 )
MINOR=$(printf "%0${digits}d\n" "$((10#$MINOR + 1))")
unset RELEASE
# next RELEASE
RELEASE=$MAJOR.$MINOR
logger "next RELEASE: $RELEASE"
echo $RELEASE
