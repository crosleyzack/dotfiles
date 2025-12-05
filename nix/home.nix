{ config, pkgs, ... }:

{
  imports = [
    ./home/pkgs.nix
    ./home/cli.nix
    ./home/git.nix
    ./home/tmux.nix
    ./home/code.nix
  ];

  home = {
    username = "crosleyzack";
    homeDirectory = "/home/crosleyzack";
    stateVersion = "25.11";
    shell.enableShellIntegration = true;
  };

  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;
}
