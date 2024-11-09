DOCKER_BUILDKIT=1 docker build -t podman-build22 --build-arg UBUNTU_VERSION=22.04 .
docker run --rm --mount type=bind,src=$(pwd)/output,dst=/output podman-build22 bash -c "cp /tmp/podman-*.deb /tmp/netavark-*.deb /output"
DOCKER_BUILDKIT=1 docker build -t podman-build24 --build-arg UBUNTU_VERSION=24.04 .
docker run --rm --mount type=bind,src=$(pwd)/output,dst=/output podman-build24 bash -c "cp /tmp/podman-*.deb /tmp/netavark-*.deb /output"
