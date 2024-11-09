abergeron.podman
=========

Role to install podman for Ubuntu 22.04

Important information
---------------------

This build and role are made with rootless usage in mind on a shared
computing infrastructure. Most notably the configuration that is
installed disables most of the isolation mechanisms to ensure the
contained processes have full access to hardware resources such as
GPUs and Infiniband.

If that isn't your use case you can still use the build, but make sure
to replace the config.

Example playbook
----------------

    - hosts: podman_hosts
      ansible.builtin.import_role:
        name: abergeron.podman


Configuration variables
-----------------------

All the variables are optional because they have reasonable defaults.

`podman_package_url`: The http location of a podman package file (default to the latest build from the github actions in this repo).

`netavark_package_url`: The location of a netavark package file (defaults to the latest build from the github actions in this repo).

`podman_install_from_repo`: If set to `true` it will attempt to install podman from already-configured apt repos. To make this work, you need to download the packages from the release and add them to a locally configured repo. Due to version restrictions, it will not install from the release repos.

`podman_storage_rootless`: Locations where podman will store
containers when running rootless. This can include shell variables
such as ${HOME} to have an easy per-user location.

`podman_install_from_repo`: set to `true` to assume there is a repo configured with the podman packages.

`podman_setup_nvidia`: set to `true` to install nvidia-container-toolkit for nvidia gpu support. You will still have to generate the CDI file: https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/cdi-support.html#generating-a-cdi-specification


License
-------

MIT
