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
    coreutils
    pkgs.gcc
    pkgs.cmake
    pkgs.gnumake
    pkgs.build-essential
    pkgs.ca-certificates
    pkgs.curl
    pkgs.gnupg
    pkgs.jq
    pkgs.git 
    pkgs.texlive-latex-extra
    pkgs.texlive-fonts-extra
    pkgs.vim
    pkgs.fonts-powerline
    pkgs.postgresql-client
    pks.pipenv
    pkgs.python3
    pkgs.libssl-dev 
    pkgs.libbz2-dev
    pkgs.libsqlite3-dev
    pkgs.wget
    pkgs.llvm
    pkgs.libncursesw5-dev
    pkgs.tk-dev
    pkgs.xsel
    pkgs.net-tools
    pkgs.ranger
    pkgs.simple-scan
    pkgs.whois
    pkgs.rdesktop
    pkgs.libtool
    pkgs.libtool-bin
    pkgs.gettext
    pkgs.unzip
    pkgs.vscode
    zoom-us
    pkgs.slack
    pkgs.firefox
    pkgs.gimp
    pkgs.imagemagick
    pkgs.gdb
    pkgs.clips
    pkgs.tor
  ];

  programs.git = {
    package = pkgs.gitAndTools.gitFull;
    enable = true;
    userName = "crosleyzack";
    userEmail = "mail@crosleyzack.com";
  };

  programs.vim = {
    enable = true;
    extraConfig = builtins.readFile vim/vimrc;
    settings = {
       relativenumber = true;
       number = true;
    };
    plugins = with pkgs.vimPlugins; [];
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    extensions = with pkgs.vscode-extensions; [
      vscode-extension-github-copilot
      vscode-extension-golang-Go
      vscode-extension-ms-python-python
      vscode-extension-ms-vscode-cmake-tools
      vscode-extension-ms-vscode-makefile-tools
      vscode-extension-GraphQL-vscode-graphql-syntax
    ];
    userSettings = {
      "terminal.integrated.fontFamily" = "Hack";
    };
  };
}
