{
  description = "My homeserver on a Raspberry pi 4";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nur.url = "github:nix-community/NUR";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    yvim = {
      url = "github:mathieudr/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:nixos/nixos-hardware";
  };
  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-unstable,
    nur,
    home-manager,
    nix-index-database,
    nixos-hardware,
    flake-utils,
    agenix,
    ...
  }:
    with inputs; let
      nixpkgsWithOverlays = with inputs; rec {
        config = {
          permittedInsecurePackages = [
          ];
        };
        overlays = [
          nur.overlay
          (_final: prev: {
            # this allows us to reference pkgs.unstable
            unstable = import nixpkgs-unstable {
              inherit (prev) system;
              inherit config;
            };
          })
        ];
      };

      configurationDefaults = args: {
        nixpkgs = nixpkgsWithOverlays;
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "hm-backup";
        home-manager.extraSpecialArgs = args;
      };

      argDefaults = {
        inherit secrets inputs self nix-index-database;
        channels = {
          inherit nixpkgs nixpkgs-unstable;
        };
      };

      mkNixosConfiguration = {
        system ? "aarch64-linux",
        hostname,
        username,
        args ? {},
        modules,
        useImageOverlay ? false,
      }: let
        specialArgs = argDefaults // {inherit hostname username;} // args;
      in
        nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules =
            [
              (configurationDefaults specialArgs)
              home-manager.nixosModules.home-manager
              agenix.nixosModules.default
            ]
            ++ (
              if useImageOverlay
              then [
                # extra config for sdImage generator
                {
                  sdImage.compressImage = false;
                }

                # Overlay
                ({...}: {
                  nixpkgs.overlays = [
                    (final: super: {
                      makeModulesClosure = x:
                        super.makeModulesClosure (x // {allowMissing = true;});
                    })
                  ];
                })
              ]
              else []
            )
            ++ modules;
        };
    in
      {
        formatter.aarch64-linux = nixpkgs.legacyPackages.aarch64-linux.alejandra;

        # REMOTE IMAGE.
        nixosConfigurations.homeserver-image = mkNixosConfiguration {
          hostname = "homeserver";
          username = "home";
          useImageOverlay = true;
          modules = [
            nixos-hardware.nixosModules.raspberry-pi-4
            ./raspberry
            "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
          ];
        };

        # BUILD CONFIG
        nixosConfigurations.homeserver = mkNixosConfiguration {
          hostname = "homeserver";
          username = "home";
          useImageOverlay = false;
          modules = [
            nixos-hardware.nixosModules.raspberry-pi-4
            ./raspberry
          ];
        };
      }
      // flake-utils.lib.eachDefaultSystem (system: let
        pkgs = import nixpkgs {
          inherit system;
          config = nixpkgsWithOverlays.config;
          overlays = nixpkgsWithOverlays.overlays;
        };
      in {
        formatter = pkgs.nixpkgs-fmt;

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            backblaze-b2
            just
            agenix.packages.${system}.default
          ];
        };
        # packages.default = self.nixosConfigurations.homeserver.config.system.build.sdImage;
      });
}
