{ pkgs, ... }:

{
  home.packages = with pkgs; [
    redis
    sqlite
    mysql84
    awscli2
    # azure-cli
    postgresql
    terraform
    terraform-docs
    google-cloud-sdk
    google-cloud-sql-proxy
    docker-credential-gcr
    amazon-ecr-credential-helper
  ];
  home.shellAliases = {
    "gcpu" = "gcloud auth login --update-adc";
    "terru" = "terraform init && terraform apply -auto-approve";
  };
}
