{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ctop
    dive
    kind
    oras
    crane
    ctlptl
    kubectl
    kubectx
    kubernetes-helm
  ];
}
