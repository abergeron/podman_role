FROM ubuntu:22.04

# Make sure this matches with the versions in files/control-*
ARG PODMAN_VERSION=5.1.1
ARG PODMAN_BUILD_REV=
ARG NETAVARK_VERSION=1.11.0
ARG NETAVARK_BUILD_REV=

RUN apt-get update -y && \
    apt-get install -y crun git golang-1.21-go go-md2man iptables \
    libassuan-dev libc6-dev libdevmapper-dev libglib2.0-dev libgpgme-dev \
    libgpg-error-dev libprotobuf-dev libprotobuf-c-dev libsystemd-dev \
    pkg-config containernetworking-plugins conmon uidmap make cargo \
    protobuf-compiler

ENV SOURCE_DIR=/tmp/src
ENV PODMAN_PACKAGE_VERSION=${PODMAN_VERSION}${PODMAN_BUILD_REV}
ENV PODMAN_TARGET_DIR=/tmp/podman-${PODMAN_PACKAGE_VERSION}
ENV NETAVARK_PACKAGE_VERSION=${NETAVARK_VERSION}${NETAVARK_BUILD_REV}
ENV NETAVARK_TARGET_DIR=/tmp/netavark-${NETAVARK_PACKAGE_VERSION}

RUN mkdir -p ${SOURCE_DIR}
RUN mkdir -p ${PODMAN_TARGET_DIR}
RUN mkdir -p ${NETAVARK_TARGET_DIR}
RUN mkdir -p /output

RUN git clone --depth 1 https://github.com/containers/podman.git -b v${PODMAN_VERSION} ${SOURCE_DIR}/podman

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/usr/lib/go-1.21/bin

RUN cd ${SOURCE_DIR}/podman && make -j4 BUILDTAGS="systemd exclude_graphdriver_btrfs" PREFIX=/usr && make install PREFIX=${PODMAN_TARGET_DIR}

COPY files/control-podman ${PODMAN_TARGET_DIR}/DEBIAN/control

RUN git clone --depth 1 https://github.com/containers/netavark.git -b v${NETAVARK_VERSION} ${SOURCE_DIR}/netavark

RUN cd ${SOURCE_DIR}/netavark && make PREFIX=/usr && make docs PREFIX=/usr && make install PREFIX=${NETAVARK_TARGET_DIR}

COPY files/control-netavark ${NETAVARK_TARGET_DIR}/DEBIAN/control

RUN cd /tmp && dpkg-deb --build podman-${PACKAGE_VERSION}
