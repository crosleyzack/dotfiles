{ pkgs, ... }:

{
  # NOTE: docker CLI and daemon come from the distro's docker-ce package
  # (installed alongside docker-ce-rootless-extras via apt). Rootless setup
  # is bootstrapped once with `dockerd-rootless-setuptool.sh install`.
  # NOTE: DOCKER_HOST is set per machine, because only some run rootless.
  # See framework/home.nix for both the shell and the systemd user session.
  home.shellAliases = {
    stop_containers = "docker stop $(docker ps -aq)";
    nuke_docker = "docker system prune -a";
  };
  home.file.docker = {
    enable = true;
    executable = false;
    target = ".config/docker/daemon.json";
    text = ''
{ "features": { "buildkit": true } }
    '';
  };
}
