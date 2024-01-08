# Ansible

Installs programs via appropriate package manager for system.

## Installing

Run `ansible-playbook -b packages.yaml --ask-become-pass`. Package name defaults are defined in `defaults.yaml`. The appropriate `<os_family>.yaml` file will be pulled for the systems os family to override default package names.

> **_NOTE:_** The "BECOME password:" will be you user password

Implemented operating system families include:
- Debian.yaml

To create a new template, copy `defaults.yaml` and replace differing package names with the name for your operating systems package manager. For valid OS Family options, see: https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_conditionals.html#ansible-facts-os-family

## Debugging

If you hang on "Gathering Facts", try doing `rm -rf ~/.ansible` to cleanup cache and try again.
