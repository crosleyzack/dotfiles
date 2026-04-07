{ pkgs, lib, ... }:

let
  codeowners = pkgs.buildGoModule {
    pname = "codeowners";
    version = "43ee129097bf93824225b5e9e764780af55c269d";
    src = pkgs.fetchFromGitHub {
      owner = "wlynch";
      repo = "codeowners";
      rev = "43ee129097bf93824225b5e9e764780af55c269d";
      hash = "sha256-EIvRcsRg3boNIpoeCp4s+LAHzMo9/tzqGPN2lruZkeo=";
    };
    vendorHash = "sha256-LF1RG87/aX97fXiee1hrn7TSD/wFh83midjm7OrCE44=";
  };
in
{
  home.packages = [
    codeowners
  ];
}
