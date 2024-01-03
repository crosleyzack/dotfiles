# Ansible

Installs programs via appropriate package manager for system.

## Installing

Run `ansible-playbook -b packages.yaml --ask-become-pass`. This will pull from the appropriate `<distribution>.yaml` the package names. Implemented distributions include:
- Debian.yaml

To create a new template, copy `Debian.yaml` and replace each variable name with the appropriate package name for your distribution.
