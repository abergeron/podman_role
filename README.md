Role Name
=========

Role to install podman for Ubuntu 22.04

How to use
----------

You first need to run the build task on a machine and it will upload
an build archive to the controller that can then be used to install on
any number of machines.

Example playbook
----------------

    - hosts: builder
      ansible.builtin.import_role:
        name: abergeron.podman
        tasks_from: build

    - hosts: machines
      ansible.builtin.import_role:
        name: abergeron.podman
        tasks_from: install

License
-------

MIT
