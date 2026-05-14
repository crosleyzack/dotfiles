#!/bin/bash

################################################################################
# YubiKey Factory Reset Script
#
# Purpose:
#   Resets all applications on a YubiKey to factory defaults. This is a
#   destructive operation that will erase all stored credentials and keys.
#
# Behavior:
#   1. Lists all connected YubiKeys using ykman
#   2. Selects target device (auto-select if only one, or use provided serial)
#   3. Prompts for confirmation before proceeding
#   4. Resets the following YubiKey applications to factory defaults:
#      - FIDO/FIDO2 (WebAuthn and U2F)
#      - HSM Auth
#      - OATH (TOTP/HOTP)
#      - OpenPGP
#      - PIV (smart card)
#
# Usage:
#   ./reset.sh [serial_number]
#
# Arguments:
#   $1 - Optional YubiKey serial number (required if multiple devices connected)
#
# Environment Variables:
#   None
#
# Prerequisites:
#   - ykman (YubiKey Manager CLI) installed
#   - YubiKey device connected
#
# WARNING:
#   This operation is IRREVERSIBLE. All credentials, keys, and certificates
#   stored on the YubiKey will be permanently deleted.
################################################################################

readarray -t DEVICES< <(ykman list --serials)
LEN=${#DEVICES[@]}
echo "DEVICES=${DEVICES[@]}, length=$LEN"

DEVICE=""
if [ -v $1 ]; then
    # if device is provided as argument, use that
    echo "setting device to $1"
    DEVICE=$1
elif [ $LEN -eq 1 ]; then
    # if there is only a single device, use that
    echo "setting device to ${DEVICES[0]}"
    DEVICE=${DEVICES[0]}
else
    echo for multiple devices a serial must be specified
    exit 1
fi

read -p "Do you want to reset ${DEVICE}? (y/n) " yn

case $yn in
	y ) echo ok, we will proceed;;
	n ) echo exiting...;
		exit;;
	* ) echo invalid response;
		exit 1;;
esac

ykman -d $DEVICE fido reset 
ykman -d $DEVICE hsmauth reset
ykman -d $DEVICE oath reset
ykman -d $DEVICE openpgp reset
ykman -d $DEVICE openpgp access set-retries 255
ykman -d $DEVICE piv reset
ykman -d $DEVICE piv access set-retries 255
