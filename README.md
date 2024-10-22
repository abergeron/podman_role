Role Name
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

`podman_pacakge_url`: By default this is the url of the latest build
from the github actions in this repo.

`podman_storage`: Location where podman will store containers when
running as root

`podman_storage_rootless`: Locations where podman will store
containers when running rootless. This can include shell variables
such as ${HOME} to have an easy per-user location.

`podman_install_from_repo`: set to `true` to assume there is a repo configured with the podman packages.

`podman_setup_nvidia`: set to `true` to install nvidia-container-toolkit for nvidia gpu support. You will still have to generate the CDI file: https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/cdi-support.html#generating-a-cdi-specification


License
-------

MIT
