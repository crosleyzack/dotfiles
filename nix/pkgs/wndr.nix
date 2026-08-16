{ pkgs, lib, ... }:

let
  wndr = pkgs.buildGoModule rec {
    pname = "wndr";
    version = "0.4.0";

    src = pkgs.fetchFromGitHub {
      owner = "crosleyzack";
      repo = "wndr";
      rev = "v${version}";
      sha256 = "sha256-kTdurVNXtcIDJVrUUmpsk2ZBdfKBomn74JFW0v8m1pQ=";
    };

    vendorHash = "sha256-vQNkSt0g60lrqTInFYoLjXx1QUkKiieG60PBvZ6YNNo=";

    meta = with lib; {
      description = "Explore tree-based file formats as an interactive TUI tree";
      homepage = "https://github.com/crosleyzack/wndr";
      license = licenses.mit;
      platforms = platforms.all;
    };
  };

in
{
  # Ensure the package is added to your user environment
  home.packages = [
    wndr
  ];
}
