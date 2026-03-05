{ pkgs, ... }:

{
  home.packages = with pkgs; [
    step-cli
    # scanning
    syft
    grype
    trivy
    # images
    apko
    melange
    # ai
    claude-code
  ];
}
