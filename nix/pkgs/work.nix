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
    docker-credential-gcr
    terraform
    terraform-docs
    buf
    grpcurl
    syft
    grype
    trivy
    apko
    melange
    # ai
    claude-code
  ];
}
