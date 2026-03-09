{ pkgs, ... }:

{
  home.packages = with pkgs; [
    podman
    podman-tui
    podman-desktop
    podman-compose
    podlet
  ];
  # config file
  home.file.containers = {
    enable = true;
    target = ".config/containers/containers.conf";
    text = ''
annotations = [ runtime=podman ]
    '';
  };
}
