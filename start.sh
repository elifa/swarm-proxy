#!/bin/sh

PORT=$1

eval CMD=\"${RUN}\"

echo "Starting container with run command '${CMD}'."

CONTAINER=`docker create --rm ${CMD}`

echo "Created container ${CONTAINER}."

docker inspect $CONTAINER

cleanup() { 
    docker stop $CONTAINER
    exit 0
}

trap cleanup SIGTERM SIGKILL

LISTEN=`echo ${PORT} | cut -d ':' -f 1`
BACKEND=`echo ${PORT} | cut -d ':' -f 2`
SERVER=`/sbin/ip route | awk '/default/ { print $3 }'`

echo "Setting up proxy from ${LISTEN} to ${BACKEND}."

socat TCP-LISTEN:${LISTEN},fork TCP:${SERVER}:${BACKEND} &

exec docker start -ai $CONTAINER