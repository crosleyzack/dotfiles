# Ansible

Installs programs via appropriate package manager for system.

## Create packages.yaml file

Run `ansible-playbook -b <template>.yaml --ask-become-pass`. Currently the options for `<template>.yaml` include:
- debian.yaml

To create a new template, copy `debian.yaml` and replace each variable name with the appropriate package name for your distribution.

This will create a `packages.yaml` file

## Installing

Install `packages.yaml` with `ansible-playbook -b packages.yaml --ask-become-pass`.
