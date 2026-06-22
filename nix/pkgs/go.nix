{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gcc
    delve
    glibc
    gopls
    gosec
    golint
    gotests
    gotools
    go-tools
    go-task
    capslock
    govulncheck
    golangci-lint
    # for pprof
    graphviz
  ];
  programs.go = {
    enable = true;
  };
}
