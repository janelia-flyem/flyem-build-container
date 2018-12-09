#!/bin/bash

CONTAINER_NAME=${1-flyem-build}

docker start ${CONTAINER_NAME}
docker attach ${CONTAINER_NAME}
