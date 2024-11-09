ARG UBUNTU_VERSION=22.04
FROM ubuntu:${UBUNTU_VERSION}
ARG UBUNTU_VERSION  # docker is weird

ARG PODMAN_VERSION=5.2.5
ARG CRUN_VERSION=1.18.2
ARG PODMAN_BUILD_REV=0
ARG NETAVARK_VERSION=1.13.0
ARG NETAVARK_BUILD_REV=0

RUN rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  apt-get update -y && \
    apt-get install -y git wget golang-1.21-go go-md2man iptables \
    libassuan-dev libc6-dev libdevmapper-dev libglib2.0-dev libgpgme-dev \
    libgpg-error-dev libprotobuf-dev libprotobuf-c-dev libsystemd-dev \
    pkg-config conmon uidmap make cargo-1.80 protobuf-compiler \
    libseccomp-dev

ENV SOURCE_DIR=/tmp/src
ENV PODMAN_PACKAGE_VERSION=${PODMAN_VERSION}-${PODMAN_BUILD_REV}
ENV PODMAN_TARGET_DIR=/tmp/podman-${PODMAN_PACKAGE_VERSION}
ENV NETAVARK_PACKAGE_VERSION=${NETAVARK_VERSION}-${NETAVARK_BUILD_REV}
ENV NETAVARK_TARGET_DIR=/tmp/netavark-${NETAVARK_PACKAGE_VERSION}

RUN mkdir -p /files
COPY files/* /files/
COPY tcat/tcat.sh /files/tcat.sh

RUN mkdir -p ${SOURCE_DIR}
RUN mkdir -p ${PODMAN_TARGET_DIR}/DEBIAN
RUN mkdir -p ${NETAVARK_TARGET_DIR}/DEBIAN
RUN mkdir -p /output

RUN git clone --depth 1 https://github.com/containers/podman.git -b v${PODMAN_VERSION} ${SOURCE_DIR}/podman

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/usr/lib/go-1.21/bin

RUN --mount=type=cache,target=/root/.cache/go-build cd ${SOURCE_DIR}/podman && make -j4 BUILDTAGS="seccomp systemd exclude_graphdriver_btrfs" PREFIX=/usr && make install PREFIX=/usr DESTDIR=${PODMAN_TARGET_DIR}

RUN wget "https://github.com/containers/crun/releases/download/${CRUN_VERSION}/crun-${CRUN_VERSION}-linux-amd64" -O ${PODMAN_TARGET_DIR}/usr/bin/crun
RUN chmod 755 ${PODMAN_TARGET_DIR}/usr/bin/crun

RUN bash /files/tcat.sh /files/control-podman.${UBUNTU_VERSION} > ${PODMAN_TARGET_DIR}/DEBIAN/control

RUN dpkg-deb --build ${PODMAN_TARGET_DIR} /tmp/podman-${PODMAN_PACKAGE_VERSION}~${UBUNTU_VERSION}.deb

RUN git clone --depth 1 https://github.com/containers/netavark.git -b v${NETAVARK_VERSION} ${SOURCE_DIR}/netavark

RUN --mount=type=cache,target=/root/.cargo/registry cd ${SOURCE_DIR}/netavark && make CARGO=cargo-1.80 PREFIX=/usr && make docs CARGO=cargo-1.80 PREFIX=/usr && make install CARGO=cargo-1.80 PREFIX=/usr DESTDIR=${NETAVARK_TARGET_DIR}

RUN bash /files/tcat.sh /files/control-netavark.${UBUNTU_VERSION} > ${NETAVARK_TARGET_DIR}/DEBIAN/control

RUN dpkg-deb --build ${NETAVARK_TARGET_DIR} /tmp/netavark-${NETAVARK_PACKAGE_VERSION}~${UBUNTU_VERSION}.deb
