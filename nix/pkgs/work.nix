{ pkgs, ... }:

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
    # grpc-gateway
    # TODO install from protocGenGoPkgs
    # protoc-gen-go
    # myProtocGenGo
    # protoc-gen-go-grpc
    # apks
    syft
    grype
    apko
    melange
    # ai
    claude-code
  ];
}
