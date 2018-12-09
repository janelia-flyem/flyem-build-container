[![CircleCI](https://circleci.com/gh/janelia-flyem/flyem-build-container/tree/master.svg?style=shield)](https://circleci.com/gh/janelia-flyem/flyem-build-container/tree/master)

# flyem-build-container

A CentOS-6 Docker container for building FlyEM conda packages.
Based on the conda-forge `linux-anvil-comp7` docker image.


## Launch or resume

The `flyem-build` image is already uploaded to Dockerhub, so there's no need to build it.
To download and launch it for the first time on your local machine:

```
./launch.sh
``` 

When you want to re-attach to the container:

```
./resume.sh
```


## Features

- The `conda` user can run `sudo` with no password
- `miniconda` is pre-installed (in `/opt/conda`)
- Many packages are easily built and uploaded using `/flyem-workspace/ilastik-publish-packages/build-recipes.py`.  For example:
   - `./build-recipes.py flyem-recipe-specs.yaml dvid`

**Note:** Don't use `yum` to install `gcc`.  Instead, FlyEM packages should be built
using Anaconda's compiler packages (e.g. `linux_gcc-64` and `linux-gxx-64`).


### DVID development

For debugging DVID build issues in particular, a dvid development
setup is already installed.  To test the build:

```
source activate dvid-devel
cd /flyem-workspace/gopath/src/github.com/janelia-flyem/dvid
make test
```


## Maintaining the `flyem-build` container

This repo is forked from the `conda-forge/docker-images`, just to make sure we
can maintain our own tag of the `linux-anvil-comp7` container (in case they change it).

If you need to modify the `flyem-build` image, take the following steps:

1. Edit `flyem-build/Dockerfile` as needed
2. Test with `docker build --no-cache -t flyem-build -f flyem-build/Dockerfile .`
3. Tag this repo with your new tag: `git tag -a flyem-0.1 -m flyem-0.1 && git push --follow-tags origin master`
4. In your terminal, login to Dockerhub: `docker login`
5. Run `./build-container-and-push.sh`
