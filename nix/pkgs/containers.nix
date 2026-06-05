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
  home.shellAliases = {
    stop_containers = "docker stop $(docker ps -aq)";
    nuke_docker = "docker system prune -a";
  };
  # config file
  home.file.docker = {
    # NOTE: requires docker in rootless mode
    enable = true;
    executable = false;
    target = ".config/docker/daemon.json";
    text = ''
{ "features": { "buildkit": true } }
    '';
  };
}
