{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [
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
        # protobuf
        buf
        grpcurl
        protobuf
        grpc-gateway
        protoc-gen-go
        protoc-gen-go-grpc
        # apks
        apko
        melange
        # ai
        claude-code
    ];
  };
}
