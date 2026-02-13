{
    description = "Framework Linux Home Manager Flake";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/release-25.11";
        home-manager = {
            url = "github:nix-community/home-manager/release-25.11";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = {nixpkgs, home-manager, ...}: {
        homeConfigurations = {
            "zackary-crosley" = home-manager.lib.homeManagerConfiguration {
                pkgs = import nixpkgs { system = "x86_64-linux"; };
                modules = [ ./home.nix ];
            };
        };
    };
}

