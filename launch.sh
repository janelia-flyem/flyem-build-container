#!/bin/bash

## Create a container from the given image from the 'flyem' Dockerhub account.

##
## Usage: ./launch [image-name] [container-name]
##
## Examples:
##
##    ./launch flyem-build my-build-container
##
##    # same as flyem-build flyem-build
##    ./launch
##

##
## If USE_X11=1, then try to permit x11 apps to work correctly in the container.
##
if [[ "${USE_X11}" == "1" ]]; then
    # On Mac, the '-e DISPLAY=...' and '-v ...' settings below will allow you to
    # view X11 GUI applications from the container, IFF you have XQuartz 2.7.11
    # installed, and  IFF you check "Allow connections from network clients" in your
    # XQuartz Preferences, as explained in the following link:
    # - https://fredrikaverpil.github.io/2016/07/31/docker-for-mac-and-gui-applications/
    #
    # Sadly, you still won't be able to use OpenGL apps, such as NeuTu.
    # But non-OpenGL GUIs will work.
    # Try testing it with the 'xeyes' program, for instance.
    # 
    # TODO: We might be able to get OpenGL apps working via a different approach
    #       using xvfb, fluxbox, and x11vnc over SSH rather than using X11 forwarding.
    #       A good example can be found here:
    #       - https://github.com/ilastik/ilastik-test-vm/blob/master/Vagrantfile#L149-L217
    #       ...but for now, that's probably more trouble than it's worth.
    ip=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')
    xhost + $ip
    X11_ARGS=" -e DISPLAY=$ip:0 -v /tmp/.X11-unix:/tmp/.X11-unix"
fi

DOCKERHUB_USER=${DOCKERHUB_USER-flyem}
IMAGE_NAME=${1-flyem-build}
CONTAINER_NAME=${2-${IMAGE_NAME}}

docker pull ${DOCKERHUB_USER}/${IMAGE_NAME}

docker run -it \
    --name ${CONTAINER_NAME} \
    -e HOST_USER_NAME=$USERNAME \
    -e HOST_USER_ID=$UID \
    -e HOST_GROUP_NAME="$(id -g -n $USERNAME || echo $USERNAME)" \
    -e HOST_GROUP_ID=$(id -g $USERNAME) \
    ${X11_ARGS} \
    ${DOCKERHUB_USER}/${IMAGE_NAME} \
##
