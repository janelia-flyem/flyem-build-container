[![CircleCI](https://circleci.com/gh/janelia-flyem/flyem-build-container/tree/master.svg?style=shield)](https://circleci.com/gh/janelia-flyem/flyem-build-container/tree/master)

# flyem-build-container

Builds a Docker container for building FlyEM conda packages.
Based on the conda-forge 'linux-anvil-comp7' image, which is based on CentOS 6.

This repo is forked from the `conda-forge/docker-images` just to make sure we
can build our own tag of the `linux-anvil` container (in case they change it).
