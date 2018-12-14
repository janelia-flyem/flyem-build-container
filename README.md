[![CircleCI](https://circleci.com/gh/janelia-flyem/flyem-build-container/tree/master.svg?style=shield)](https://circleci.com/gh/janelia-flyem/flyem-build-container/tree/master)

# flyem-build-container

A CentOS-6 Docker container for building FlyEM conda packages.
Based on the conda-forge `linux-anvil-comp7` docker image.


## Launch or resume

The `flyem-build` image is already uploaded to Dockerhub, so there's no need to build it.
To download and launch it for the first time on your local machine, clone this repo and
then run the following:

```
./launch.sh
``` 

When you want to re-attach to the container:

```
./resume.sh
```


**Note:**
If you've already launched the container once, but now want to
replace it using the latest image, you'll need to delete your old
container (or rename it) before running `./launch` again:

```
docker rm flyem-build
# OR:
docker rename flyem-build old-flyem-build

# Craetes a new container named 'flyem-build'
./launch
```

## Features

- The `conda` user can run `sudo` with no password
- `miniconda` is pre-installed (in `/opt/conda`)
- A convenience script for building and uploading our conda packages is installed to `/flyem-workspace/ilastik-publish-packages/build-recipes.py`.
   - Example usage: `./build-recipes.py flyem-recipe-specs.yaml libdvid-cpp`

**Note:** Don't use `yum` to install `gcc`.  Instead, FlyEM packages should be built
using Anaconda's compiler packages (e.g. `linux_gcc-64` and `linux-gxx-64`).


### DVID development

For debugging DVID build issues in particular, a dvid development
tree is already created, but the dependencies are not pre-downloaded.
To initialize the dvid developer setup, and test the build, run these commands:

```
source activate dvid-devel
cd /flyem-workspace/gopath/src/github.com/janelia-flyem/dvid
git pull origin master
./scripts/install-developer-dependencies.sh
make dvid
make test
```

## Tips

#### Tune your Docker settings

If you're running Docker for Mac, you should probably allocate more RAM to the
Docker VM ("Docker Engine") than it starts with by default.
From the Docker menu at the top of your screen, select "Preferences" and find the "Advanced" tab.
Set Memory to something reasonable (e.g. at least 4 GB).

#### Useful Docker commands

```bash
# List all of your downloaded images (from which containers could be created)
docker images

# List all of your currently running containers
docker ps

# List all of your currently running AND stopped containers (which could be resumed via 'docker start')
docker ps -a

# Delete a container (e.g. flyem-build)
docker rm flyem-build

# Delete an image (e.g. the 'flyem-0.1' tag of image 'flyem/flyem-build')
docker rmi flyem/flyem-build:flyem-0.1
```

## Maintaining the `flyem-build` container

This repo is forked from the `conda-forge/docker-images`, just to make sure we
can maintain our own tag of the `linux-anvil-comp7` container (in case they change it).

If you need to modify the `flyem-build` image, take the following steps:

1. Edit `flyem-build/Dockerfile` as needed.
2. Test with:
   - `docker build -t flyem-build -f flyem-build/Dockerfile .`
   - Note: If your Dockerfile is pulling git repos that have changed recently, you may want to use `--nocache`:
      - `docker build -t flyem-build -f flyem-build/Dockerfile --nocache .`
3. Tag this repo with your new tag:
   - `git tag -a flyem-0.1 -m flyem-0.1 && git push --follow-tags origin master`
4. In your terminal, login to Dockerhub:
   - `docker login`
5. Build the image and push it to Dockerhub:
   -  `./build-image-and-push.sh`


## FAQ

- `No space left on device` -- how do I fix it?
   - Docker for Mac runs all docker containers in a VM, and all of your docker images share a single disk, which has a fixed size.
     One quick fix is to increase the disk size in your docker preferences.  (See the Docker Menu at the top of your screen.)
     But you can't keep increasing that limit indefinitely.  A better option is to delete all of your old unused containers and images.
     One guide to doing so can be found [here](http://jimhoskins.com/2013/07/27/remove-untagged-docker-images.html).

- How do I extract files from the container?
   - Use `docker cp`.  For example, extract `foobar` into your local `/tmp` directory:
      - `docker cp flyem-build:/flyem-workspace/foobar /tmp`
   - The file permissions on the extracted files will match your username, thanks to a [trick][] from the conda-forge team.

- Who can use the binaries I generate in the container?
   - Almost any Linux user. Our conda packages have no external dependencies except for `glibc.so`.
     The container is running CentOS-6, which uses `glibc 2.12`.
     Any Linux distro with a newer version of `glibc` can run our binaries.
     Here are some helpful distrowatch pages: [Ubuntu][], [CentOS][], [Scientific Linux][]

- I want to add some steps to the `Dockerfile`, but it won't let me add anything to `/home/conda`.  What gives?
   - The `conda` user does not actually exist until AFTER the container is fully built.  (See `scripts/entrypoint`.)
     Write your files into `/flyem-workspace`.  To give the `conda` user access to the files, make sure they belong
     to the `lucky` group.  (If your files are in `/flyem-workspace` or `/opt/conda`, then the group permissions are
     automatically set for you.  See the last lines of `flyem-build/Dockerfile`.)

- I'm seeing [strange errors][] when I run the DVID test suite in the container.
   - Make sure Docker has enough RAM.  See "Tune your Docker settings", above.

[trick]: https://github.com/janelia-flyem/flyem-build-container/blob/master/scripts/entrypoint#L3-L5
[CentOS]: https://distrowatch.com/table.php?distribution=centos
[Ubuntu]: https://distrowatch.com/table.php?distribution=ubuntu
[Scientific Linux]: https://distrowatch.com/table.php?distribution=scientific
[strange errors]: https://github.com/janelia-flyem/dvid/issues/299