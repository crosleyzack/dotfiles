{ pkgs, ... }:

{
  home.packages = with pkgs; [
    step-cli
    # cloud
    redis  
    sqlite
    mysql84
    azure-cli
    postgresql
    terraform
    terraform-docs
    google-cloud-sdk
    google-cloud-sql-proxy
    docker-credential-gcr
    # scanning
    syft
    grype
    trivy
    # images
    apko
    melange
    # ai
    claude-code
  ];
}
