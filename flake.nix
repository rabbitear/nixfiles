{
  description = "Rabbitear's NixOS + Home Manager flake setup";

  inputs = {
    # Nixpkgs 25.11 release
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    # Home Manager 25.11 release, follows nixpkgs
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # flake-utils makes multi-system builds easier
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, home-manager, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true; # if you use unfree packages
        };

        # Bring in your ort.nix as a custom package
        ort = pkgs.callPackage ./pkgs/ort.nix { };
      in {
        packages.ort = ort;
      }
    )
    // {
      nixosConfigurations = {
        hacknet = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux"; # or aarch64-linux if ARM
          modules = [
            ./hosts/hacknet/configuration.nix

            # Enable Home Manager as a NixOS module
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.kreator = import ./home/kreator/home.nix;
            }
          ];
        };
      };
    };
}
