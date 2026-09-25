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

        # One line for each machine: the id of that machine, and the name of
        # the user on it.
        #
        # The id names the directory that holds home.nix, and it names the
        # configuration below. Thus one command runs on every machine, with the
        # id of that machine after the "#":
        #     home-manager switch -b backup --flake ~/dev/dotfiles/nix#framework
        #
        # install.sh and update.sh read the id from NIX_SYSTEM_ID, or from the
        # file that install.sh writes.
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
                    # Gives the id back to the shell, for startup_program.sh
                    # and for update.sh.
                    home.sessionVariables.NIX_SYSTEM_ID = id;
                }
            ];
        };
    in {
        homeConfigurations = lib.mapAttrs mkHome machines;
    };
}
