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
    docker-credential-helpers
    amazon-ecr-credential-helper
  ];

  home.shellAliases = {
    "gcpu" = "gcloud auth login --update-adc";
    "terru" = "terraform init && terraform apply -auto-approve";
  }; 

  # gcr.io -> docker-credential-gcr (Google's helper; uses gcloud/ADC creds).
  home.file.gcloud_cred_helper = {
    enable = true;
    target = ".local/bin/docker-credential-gcloud";
    source = "${pkgs.docker-credential-gcr}/bin/docker-credential-gcr";
  };

  # *.dkr.ecr.*.amazonaws.com -> docker-credential-ecr (AWS's helper; upstream
  # names the binary docker-credential-ecr-login).
  home.file.ecr_cred_helper = {
    enable = true;
    target = ".local/bin/docker-credential-ecr";
    source = "${pkgs.amazon-ecr-credential-helper}/bin/docker-credential-ecr-login";
  };
}
