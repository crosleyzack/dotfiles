################################################################################
# Settings of every machine.
#
# A machine holds its own file at <id>/home.nix, and that file holds only what
# separates that machine from the others: the list of packages, the identity of
# git, and the hardware.
#
# flake.nix gives the name of the user, the home directory, and NIX_SYSTEM_ID,
# because the table of that file already holds the name of every machine.
################################################################################
{ pkgs, ... }:

{
  home = {
    stateVersion = "26.05";
    sessionVariables = {
      MOZ_ENABLE_WAYLAND = 1;
      EDITOR = "vim";
      DO_NOT_TRACK = "1";
    };
    sessionPath = [
      "$HOME/go/bin"
      "$HOME/.local/bin"
    ];
    shell.enableShellIntegration = true;
    shellAliases = {
      ls = "ls --color=auto";
    };
  };

  # allow non-free packages to be installed, like terraform
  nixpkgs.config.allowUnfree = true;

  nix.package = pkgs.nix;

  # A machine adds "experimental-features" to this set, because the list is not
  # the same on every one of them.
  nix.settings = {
    max-jobs = "auto";
    cores = 0;
    auto-optimise-store = true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 10d";
  };

  programs.home-manager.enable = true;
}
