{ config, pkgs, ... }:

{
  imports = [
    ./home/pkgs.nix
    ./home/go.nix
    ./home/cli.nix
    ./home/git.nix
    ./home/tmux.nix
    ./home/code.nix
  ];

  home = {
    username = "crosleyzack";
    homeDirectory = "/home/crosleyzack";
    stateVersion = "25.11";
    # for fedora machines
    # shellAliases = {
    #  docker = "podman";
    #};
    shell.enableShellIntegration = true;
  };

  # allow non-free packages to be installed, like terraform
  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;
}
