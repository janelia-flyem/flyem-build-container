#!/bin/bash

## Create a container from the given image from the 'flyem' Dockerhub account.

##
## Usage: ./launch [image-name] [container-name]
##
## Examples:
##
##    ./launch # defaults to flyem-build
##    ./launch flyem-build my-build-container
##

IMAGE_NAME=${1-flyem-build}
CONTAINER_NAME=${2-${IMAGE_NAME}}

ACCOUNT_NAME=flyem

docker run -it \
    --name ${CONTAINER_NAME} \
    -e HOST_USER_NAME=$USERNAME \
    -e HOST_USER_ID=$UID \
    -e HOST_GROUP_NAME="$(id -g -n $USERNAME || echo $USERNAME)" \
    -e HOST_GROUP_ID=$(id -g $USERNAME) \
    ${ACCOUNT_NAME}/${IMAGE_NAME} \
##
