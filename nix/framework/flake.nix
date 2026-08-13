{
    description = "Framework Linux Home Manager Flake";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
        home-manager = {
            url = "github:nix-community/home-manager/release-26.05";
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

