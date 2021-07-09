FROM harbor.mellanox.com/hpcx/x86_64/rhel7.0/builder:inbox

# MOFED
ARG MOFED_VERSION
ARG MOFED_OS
ENV MOFED_DIR MLNX_OFED_LINUX-${MOFED_VERSION}-${MOFED_OS}-x86_64
ENV MOFED_SITE_PLACE MLNX_OFED-${MOFED_VERSION}
ENV MOFED_IMAGE ${MOFED_DIR}.tgz
RUN yum -y install wget  && yum clean all && \
    wget --no-verbose http://content.mellanox.com/ofed/${MOFED_SITE_PLACE}/${MOFED_IMAGE} && \
    tar -xzf ${MOFED_IMAGE} && \
    ${MOFED_DIR}/mlnxofedinstall --all -q \
        --user-space-only \
        --without-fw-update \
        --skip-distro-check \
        --without-ucx \
        --without-hcoll \
        --without-openmpi \
        --without-sharp \
        --force \
    && rm -rf ${MOFED_DIR} && rm -rf *.tgz

RUN wget https://developer.download.nvidia.com/compute/cuda/11.4.0/local_installers/cuda-repo-rhel7-11-4-local-11.4.0_470.42.01-1.x86_64.rpm && \
    rpm -i cuda-repo-rhel7-11-4-local-11.4.0_470.42.01-1.x86_64.rpm && \
    yum clean all && \
    yum -y install nvidia-driver-latest-dkms cuda && \
    yum -y install cuda-drivers && \
    rm -rf cuda-repo-rhel7-11-4-local-11.4.0_470.42.01-1.x86_64.rpm