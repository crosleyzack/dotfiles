#!/bin/bash

if ! command -v go &> /dev/null
then
    echo "go could not be found"
    exit 1
fi

# install protobuf compiler v29.3
FNAME="protoc-29.3-linux-x86_64.zip"
DIR="$HOME/temp/protoc"

mkdir -p $DIR
rm -rf $DIR/*
rm -rf $DIR/$FNAME
rm -f $HOME/.local/bin/protoc
rm -rf $HOME/.local/include

# install protobuf compiler v29.3
wget https://github.com/protocolbuffers/protobuf/releases/download/v29.3/protoc-29.3-linux-x86_64.zip -P $DIR
unzip -d $HOME/.local $DIR/$FNAME
rm -rf $DIR

# install packages only available via go install
go install github.com/crosleyzack/xplr@latest
go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.34.2
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.5.1
go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway@v2.22.0
go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2@v2.22.0
go install github.com/protoc-gen/protoc-gen-openapiv3@latest
