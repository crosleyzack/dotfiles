{ pkgs, lib, ... }:

let
  # WIP - this ends up in /nix/store but not in ~/.nix-profile/bin
  customProtoc = pkgs.buildGoModule rec {
    pname = "protoc-test"; # Name of your application
    version = "29.3";   # Version of the application

    src = pkgs.fetchFromGitHub {
      owner = "protocolbuffers";
      repo = "protobuf";
      rev = "v${version}"; # The specific Git tag or commit hash
      sha256 = "sha256-ex0ya6drPoC0GhCtlBm2Wz0Qo3RPxBQwSkHU3XUozag=";
    };

    vendorHash = "sha256-yVeuz/S1VPEXDK/AOIGpS/gefdGnyWnMG/IJjB3ctDM=";

    meta = with lib; {
      description = "Compiler for Google's language-neutral, platform-neutral, extensible mechanism for serializing structured data";
      homepage = "https://github.com/protocolbuffers/protobuf";
      license = licenses.bsd3; # Choose the correct license
      platforms = platforms.all;
    };
  };

in
{
  # Ensure the package is added to your user environment
  home.packages = [
    customProtoc
  ];
}
