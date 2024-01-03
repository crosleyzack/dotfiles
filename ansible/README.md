# Ansible

Installs programs via appropriate package manager for system.

## Installing

Run `ansible-playbook -b packages.yaml --ask-become-pass`. This will pull from the appropriate `<os_family>.yaml` the package names.

> **_NOTE:_** The "BECOME password:" will be you user password

Implemented operating systems include:
- Debian.yaml

To create a new template, copy `Debian.yaml` and replace each variable name with the appropriate package name for your operating systems package manager. For valid OS Family options, see: https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_conditionals.html#ansible-facts-os-family
