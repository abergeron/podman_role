docker build -t podman-build -f Dockerfile.22.04 .
docker run --rm --mount type=bind,src=$(pwd)/output,dst=/output podman-build bash -c "cp /tmp/podman-*.deb /tmp/netavark-*.deb /output"
docker build -t podman-build -f Dockerfile.24.04 .
docker run --rm --mount type=bind,src=$(pwd)/output,dst=/output podman-build bash -c "cp /tmp/podman-*.deb /tmp/netavark-*.deb /output"
