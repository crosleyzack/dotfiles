{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gcc
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
    packages = {
      # install xplr v0.2.4
      "github.com/crosleyzack/xplr" = builtins.fetchTarball {
        url = "https://github.com/crosleyzack/xplr/archive/refs/tags/v0.2.4.tar.gz";
        sha256 = "sha256:1f0rvk3ikcd72gqcg21y4pyjyk7c8j5lb6b4ina7v6yx63293b0a";
      };
    };
  };
}
