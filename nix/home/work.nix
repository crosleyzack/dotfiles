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
    # protobuf
    buf
    grpcurl
    # protobuf
    grpc-gateway
    # protoc-gen-go
    protoc-gen-go-grpc
    # apks
    apko
    melange
    # ai
    claude-code
  ];
  programs.go.packages = {
    # install protoc-gen-openapiv3
    "https://github.com/protoc-gen/protoc-gen-openapiv3" = builtins.fetchTarball {
      url = "https://github.com/protoc-gen/protoc-gen-openapiv3/archive/refs/tags/v0.7.7.tar.gz";
      sha256 = "sha256:1vs14qk0hbmhb8p89c84cmb2hamba8y42jf40dwv25pf37g342vv";
    };
    # install protoc 28.3
    "https://github.com/protocolbuffers/protobuf" = builtins.fetchTarball {
      url = "https://github.com/protocolbuffers/protobuf/releases/download/v28.3/protobuf-28.3.tar.gz";
      sha256 = "sha256:10w5c44wyjf29kb2r5pgqy8bahaq46a9lba2wybipkqk293zkdpr";
    };
    # install protoc-gen-go 1.34.2
    "github.com/protocolbuffers/protobuf-go" = builtins.fetchTarball {
      url = "https://github.com/protocolbuffers/protobuf-go/releases/download/v1.34.2/protoc-gen-go.v1.34.2.linux.amd64.tar.gz";
      sha256 = "sha256:0p7i5hsgli9mpm4n9g5ndx3g6n67c9ym9pnrsck79vrrc6542ryj";
    };
  };
}
