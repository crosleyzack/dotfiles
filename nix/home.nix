{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "crosley";
  home.homeDirectory = "/home/crosley";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = [
    pkgs.coreutils
    pkgs.gcc
    pkgs.cmake
    pkgs.gnumake
    pkgs.curl
    pkgs.nmap
    pkgs.man
    pkgs.gnupg
    pkgs.gdb
    pkgs.binutils
    pkgs.diffutils
    pkgs.findutils
    pkgs.tcpdump
    pkgs.jq
    pkgs.wget
    pkgs.llvm
    pkgs.ncurses
    pkgs.xsel
    pkgs.inetutils
    pkgs.less
    pkgs.libtool
    pkgs.gettext
    pkgs.gdb
    pkgs.zip
    pkgs.gzip
    pkgs.unzip
    pkgs.gnugrep
    pkgs.gnused
    pkgs.pipenv
    pkgs.python3
    pkgs.tmux
    pkgs.git-lfs
    pkgs.clips
    pkgs.tor
    pkgs.rdesktop
    pkgs.ranger
    pkgs.zsh
    pkgs.texlive.combined.scheme-medium
    pkgs.postgresql
    pkgs.protobuf
    pkgs.grpcurl
    pkgs.simple-scan
    pkgs.go
    pkgs.docker
    pkgs.alacritty
    pkgs.yubikey-manager
    pkgs.gimp
    pkgs.imagemagick
    pkgs.bitwarden
    pkgs.firefox
    pkgs.vscode
    pkgs.spotify
    pkgs.slack
    pkgs.zoom-us
  ];
}
