{ pkgs, ... }:

{
  home.packages = with pkgs; [
    redis
    sqlite
    mysql84
    awscli2
    azure-cli
    postgresql
    terraform
    terraform-docs
    google-cloud-sdk
    google-cloud-sql-proxy
    docker-credential-gcr
  ];
  home.shellAliases = {
    "gcpu" = "gcloud auth login --update-adc";
  };
}
