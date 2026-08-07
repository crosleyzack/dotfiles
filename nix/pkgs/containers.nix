{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ctop
    dive
    kind
    oras
    crane
    ctlptl
    skopeo
    buildah
    kubectl
    kubectx
    kubernetes-helm
  ];
}
