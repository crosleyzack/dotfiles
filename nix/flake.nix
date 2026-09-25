{
    description = "Home Manager configuration of every machine";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
        # Holds a package that the release keeps at a version too old. Read it
        # as pkgs.unstable.<name>. home-manager stays on the release, because
        # the module of a program expects the names of that release.
        nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager/release-26.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { nixpkgs, nixpkgs-unstable, home-manager, ... }:
    let
        inherit (nixpkgs) lib;
        system = "x86_64-linux";

        # home-manager imports nixpkgs a second time, with the config of
        # common.nix and the overlays of the pkgs below. This overlay thus runs
        # again there, and prev.config holds allowUnfree at that moment.
        unstable-overlay = final: prev: {
            unstable = import nixpkgs-unstable {
                inherit system;
                inherit (prev) config;
            };
        };

        pkgs = import nixpkgs {
            inherit system;
            overlays = [ unstable-overlay ];
        };

        # One line for each machine: the directory of that machine, and the
        # name of the user on it.
        #
        # The home-manager command reads homeConfigurations.<name of the user>
        # when the flake reference holds no "#". The name is different on every
        # machine, thus one command covers all of them:
        #     home-manager switch -b backup --flake ~/dev/dotfiles/nix
        machines = {
            framework = "zackary-crosley";
            lenovo = "crosleyzack";
            google = "zackary_crosley_chainguard_dev";
        };

        mkHome = id: username: home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [
                ./common.nix
                ./${id}/home.nix
                {
                    home.username = username;
                    home.homeDirectory = "/home/${username}";
                    # startup_program.sh and install.sh read this name.
                    home.sessionVariables.NIX_SYSTEM_ID = id;
                }
            ];
        };
    in {
        homeConfigurations = lib.mapAttrs' (
            id: username: lib.nameValuePair username (mkHome id username)
        ) machines;
    };
}
