{ pkgs, ... }:

let
  protocPkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/f62d6734af4581af614cab0f2aa16bcecfc33c11.tar.gz";
    sha256 = "sha256:10w5c44wyjf29kb2r5pgqy8bahaq46a9lba2wybipkqk293zkdpr";
  });
  myProtoc = protocPkgs.protobuf;
  protocGenGoPkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/2c36ece932b8c0040893990da00034e46c33e3e7.tar.gz";
    sha256 = "sha256:10w5c44wyjf29kb2r5pgqy8bahaq46a9lba2wybipkqk293zkdpr";
  });
  myProtocGenGo = protocGenGoPkgs.protoc-gen-go;
in
{
  home.packages = with pkgs; [
    step-cli
    redis  
    sqlite
    mysql84
    postgresql
    google-cloud-sdk
    google-cloud-sql-proxy
    kind
    helm
    crane
    ctlptl
    kubectl
    kubectx
    terraform
    terraform-docs
    docker-credential-gcr
    # TODO install from protocPkgs
    # protobuf
    # myProtoc
    buf
    grpcurl
    grpc-gateway
    # TODO install from protocGenGoPkgs
    # protoc-gen-go
    # myProtocGenGo
    protoc-gen-go-grpc
    # apks
    apko
    melange
    # ai
    claude-code
  ];
}
