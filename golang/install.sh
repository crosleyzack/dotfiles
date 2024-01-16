#!/bin/sh

# https://go.dev/doc/install
mkdir -p $HOME/temp && rm -f $HOME/temp/go.tar.gz
curl -L -o $HOME/temp/go.tar.gz https://go.dev/dl/go1.21.6.linux-amd64.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf $HOME/temp/go.tar.gz
export PATH=$PATH:/usr/local/go/bin

# golang tools
go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest
# go get -u go.mozilla.org/sops/cmd/sops
