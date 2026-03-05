{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ctop
    dive
    kind
    oras
    crane
    ctlptl
    kubectl
    kubectx
    kubernetes-helm
  ];
  # config file
  home.file.docker = {
    # NOTE: requires docker in rootless mode
    enable = true;
    target = ".config/docker/daemon.json";
    text = ''
{ "features": { "buildkit": true } }
    '';
  };
}
