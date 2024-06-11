FROM: ubuntu:22.04
# Make sure this matches with the version in files/control
ARG PODMAN_VERSION=5.0.2
ARG BUILD_REV=

RUN apt-get update -y && \
    apt-get install -y crun git golang-1.21-go go-md2man iptables \
    libassuan-dev libc6-dev libdevmapper-dev libglib2.0-dev libgpgme-dev \
    libgpg-error-dev libprotobuf-dev libprotobuf-c-dev libsystemd-dev \
    pkg-config containernetworking-plugins conmon uidmap make

ENV SOURCE_DIR=/tmp/src
ENV PACKAGE_VERSION=${PODMAN_VERSION}${BUILD_REV}
ENV TARGET_DIR=/tmp/podman-${PACKAGE_VERSION}

RUN mkdir -p ${SOURCE_DIR}
RUN mkdir -p ${TARGET_DIR}
RUN mkdir -p /output

RUN git clone --depth 1 https://github.com/containers/podman.git -b v{PODMAN_VERSION} ${SOURCE_DIR}/podman

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/usr/lib/go-1.21/bin

RUN cd ${SOURCE_DIR}/podman && make -j4 BUILDTAGS="systemd exclude_graphdriver_btrfs" PREFIX=/usr && make install PREFIX=${TARGET_DIR}

COPY files/control ${TARGET_DIR}/DEBIAN/control

RUN cd /tmp dpkg-deb --build podman-${PACKAGE_VERSION}
