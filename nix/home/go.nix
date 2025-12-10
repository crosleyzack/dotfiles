{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gcc
    glibc
    golint
    gopls
    gotests
    gotools
    go-tools
    go-task
    golangci-lint
  ];
  programs.go = {
    enable = true;
    packages = {
      # install xplr v0.2.4
      "github.com/crosleyzack/xplr" = builtins.fetchTarball {
        url = "https://github.com/crosleyzack/xplr/archive/refs/tags/v0.2.4.tar.gz";
        sha256 = "sha256:1f0rvk3ikcd72gqcg21y4pyjyk7c8j5lb6b4ina7v6yx63293b0a";
      };
      # install protoc-gen-openapiv3
      "https://github.com/protoc-gen/protoc-gen-openapiv3" = builtins.fetchTarball {
        url = "https://github.com/protoc-gen/protoc-gen-openapiv3/archive/refs/tags/v0.7.7.tar.gz";
        sha256 = "sha256:1vs14qk0hbmhb8p89c84cmb2hamba8y42jf40dwv25pf37g342vv";
      };
    };
  };
}
