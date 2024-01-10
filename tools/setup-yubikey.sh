#!/bin/bash

V=$(sudo udevadm --version)
if [ $V -lt 244 ]
then
	echo "WARN: you need at least udevadm version 244 but you have $V"
	exit 1
fi
echo "We will generate your key. You do not need to change the file location"
ssh-keygen -t ecdsa-sk -O application=ssh:YkeyCensys
PRIV="$HOME/.ssh/id_ecdsa_sk"
PUB="$HOME/.ssh/id_ecdsa_sk.pub"
ssh-add -L
