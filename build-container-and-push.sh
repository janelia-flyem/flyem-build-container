#!/bin/bash

if [ "$#" -ne 1 ]; then
    1>&2 echo "Usage:"
    1>&2 echo ""
    1>&2 echo "  $0 linux-anvil-comp7"
    1>&2 echo "  $0 flyem-build"
    exit 1
fi

TAG=$(git describe)

DOCKERHUB_ACCOUNT=flyem

IMAGE_NAME=$1
docker build -t ${DOCKERHUB_ACCOUNT}/${IMAGE_NAME}:${TAG} -f ${IMAGE_NAME}/Dockerfile --no-cache .

# Create an additional tag 'latest'
docker tag ${DOCKERHUB_ACCOUNT}/${IMAGE_NAME}:${TAG} ${DOCKERHUB_ACCOUNT}/${IMAGE_NAME}:latest

# Push the container twice, using both tags (versioned and 'latest')
docker push ${DOCKERHUB_ACCOUNT}/${IMAGE_NAME}:${TAG}
docker push ${DOCKERHUB_ACCOUNT}/${IMAGE_NAME}:latest
