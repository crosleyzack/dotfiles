{ pkgs, ... }:

{
  # NOTE: docker CLI and daemon come from the distro's docker-ce package
  # (installed alongside docker-ce-rootless-extras via apt). Rootless setup
  # is bootstrapped once with `dockerd-rootless-setuptool.sh install`.
  home.sessionVariables = {
    DOCKER_HOST = "unix://$XDG_RUNTIME_DIR/docker.sock";
  };
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
