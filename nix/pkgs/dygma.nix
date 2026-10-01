{ pkgs, ... }:

let
  # Bazecor finds the keyboard with "udevadm info -e". The FHS sandbox of
  # nixpkgs holds no udevadm, thus the search fails with ENOENT. The package
  # gives no option for extraPkgs, thus this wraps wrapAppImage to add it.
  bazecor = pkgs.bazecor.override {
    appimageTools = pkgs.appimageTools // {
      wrapAppImage = args: pkgs.appimageTools.wrapAppImage (args // {
        extraPkgs = p: (args.extraPkgs p) ++ [ p.systemdMinimal ];
      });
    };
  };
in
{
  # NOTE: udev on a host that is not NixOS does not read the rules of this
  # package. Run dotfiles/dygma/setup.sh one time to copy them to /etc.
  home.packages = [ bazecor ];
}
