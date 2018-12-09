#!/bin/bash

IMAGE_NAME=${1-flyem-build}
CONTAINER_NAME=${2-${IMAGE_NAME}}

docker run -it \
    --name ${CONTAINER_NAME} \
    -e HOST_USER_NAME=$USERNAME \
    -e HOST_USER_ID=$UID \
    -e HOST_GROUP_NAME="$(id -g -n $USERNAME || echo $USERNAME)" \
    -e HOST_GROUP_ID=$(id -g $USERNAME) \
    ${IMAGE_NAME} \
##
