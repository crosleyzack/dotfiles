{ pkgs, ... }:

{
  home.packages = with pkgs; [
    step-cli
    # scanning
    syft
    grype
    trivy
    # images
    cue
    apko
    melange
  ];
}
