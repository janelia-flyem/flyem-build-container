# We start from conda-forge's docker container for
# building recipes with Anaconda's gcc-7 compiler.
#
# Their Dockerfile is here:
# https://github.com/conda-forge/docker-images/blob/master/linux-anvil-comp7/Dockerfile
FROM flyem/linux-anvil-comp7

# The 'conda' user gets permission to use sudo for any command, without a password
#
# Note: The 'conda' user doesn't exist at the time the container is built,
#       so /home/conda doesn't exist yet.  The 'conda' user is created upon entry
#       when the container is first run via 'docker run'
RUN echo 'conda ALL=NOPASSWD: ALL' >> /etc/sudoers

# No root password
RUN echo "root:" | chpasswd

# Make sure conda is on the path
ENV PATH /opt/conda/bin:${PATH}

# Pin conda and conda-build to known-working versions
RUN conda install -n base -y conda=4.6.14 conda-build=3.17.8

# Create a workspace for our code
# This can't be located in /home/conda because /home/conda doesn't exist yet!
# (It's created by the entrypoint script.)
ENV FLYEM_WORKSPACE /flyem-workspace
RUN mkdir ${FLYEM_WORKSPACE}

# Add flyem-forge to ~/.condarc
RUN conda config --add channels flyem-forge

# Many FlyEM packages are built with this tool.
RUN conda install -n base -y publish-conda-stack
RUN git clone https://github.com/janelia-flyem/flyem-conda-recipes ${FLYEM_WORKSPACE}/flyem-conda-recipes

#
# Pre-initialize the DVID developer setup for dvid developers
# who want to debug linux-specific build issues.
#
RUN conda create -n dvid-devel
ENV PATH /opt/conda/envs/dvid-devel/bin:${PATH}
ENV GOPATH ${FLYEM_WORKSPACE}/gopath
ENV DVID_SRC ${GOPATH}/src/github.com/janelia-flyem/dvid
RUN git clone https://github.com/janelia-flyem/dvid ${DVID_SRC}

# Don't actually populate the environment with dependencies; it makes the container too darn heavy.
# DVID developers will need to run these commands manually.
#RUN source activate dvid-devel && cd ${DVID_SRC} && ./scripts/install-developer-dependencies.sh
#RUN conda clean -tsy

# Extra GL dependencies; needed by NeuTu
RUN yum install -y libGLU-devel libXi

# We modified the original entrypoint script (from condaforge/linux-anvil-comp7)
# to avoid re-creating the conda user every time we re-attach to the container.
# Overwrite it in the container
COPY flyem-build/entrypoint /opt/docker/bin/entrypoint

#
# The 'conda' user is a member of the 'lucky' group.
# Make sure that user has full access to /flyem-workspace and /opt/conda
#
RUN chgrp -R lucky ${FLYEM_WORKSPACE} && chmod -R g=u ${FLYEM_WORKSPACE}
RUN chgrp -R lucky /opt/conda && chmod -R g=u /opt/conda
