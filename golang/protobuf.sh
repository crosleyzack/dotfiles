#!/bin/bash

FNAME="protoc-29.3-linux-x86_64.zip"
DIR="$HOME/temp/protoc"

mkdir -p $DIR
rm -rf $DIR/*
rm -rf $DIR/$FNAME
rm -f $HOME/.local/bin/protoc

# install protobuf compiler v29.3
wget https://github.com/protocolbuffers/protobuf/releases/download/v29.3/protoc-29.3-linux-x86_64.zip -P $DIR
unzip -d $DIR $DIR/$FNAME
cp $DIR/bin/protoc $HOME/.local/bin
rm -rf $DIR

go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.34.2
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.5.1
go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway@v2.22.0
go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2@v2.22.0

