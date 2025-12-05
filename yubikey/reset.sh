#!/bin/bash

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
ykman -d $DEVICE piv reset
