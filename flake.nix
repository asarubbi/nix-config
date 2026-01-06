{
  description = "NixOS Flake - Multi-System Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nix-darwin, ... }@inputs: 
  let 
    systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
    packageSetsFor = system: import ./modules/common/packages.nix {
      pkgs = nixpkgs.legacyPackages.${system};
    };
    profilePackagesFor = system: profile: (packageSetsFor system).profiles.${profile};

    # --- Helper Functions ---

    # Helper for creating NixOS configurations
    mkNixos = { hostname, username, profile, system ? "x86_64-linux", modules ? [] }: 
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          profilePackages = profilePackagesFor system profile;
          profileFonts = (packageSetsFor system).fonts;
        };
        modules = [
          ./hosts/${hostname}/configuration.nix
          ./modules/nixos/packages.nix
        ] ++ modules;
      };

    # Helper for creating macOS (Darwin) configurations
    mkDarwin = { username, profile, system ? "aarch64-darwin", modules ? [] }:
      nix-darwin.lib.darwinSystem {
        inherit system;
        modules = [
          ./modules/darwin/base.nix
          ./modules/darwin/packages.nix
        ] ++ modules;
        specialArgs = {
          profilePackages = profilePackagesFor system profile;
          profileFonts = (packageSetsFor system).fonts;
        };
      };

  in { 
    
    # --- NixOS Hosts ---
    nixosConfigurations = {
      
      # titan: i3 Window Manager
      titan = mkNixos {
        hostname = "DARK-PORTAL";
        username = "asarubbi"; # Corrected username
        profile = "titan";
        modules = [
          ./modules/nixos/i3-wm.nix
          ./modules/nixos/nvidia.nix
          ./modules/nixos/gaming.nix
          ./modules/nixos/virtualization.nix
          ./modules/nixos/printing.nix
          ./modules/nixos/1password.nix
          ./modules/nixos/zsa-keyboards.nix
        ];
      };

      # devbox: Minimal development environment
      devbox = mkNixos {
        hostname = "devbox";
        username = "adsbvm"; # A new user for the devbox
        profile = "devbox";
        modules = [
          ./modules/nixos/i3-wm.nix
          # No gaming, nvidia, etc. by default. Just core CLI and development tools.
        ];
      };
    };

    # --- macOS Hosts ---
    darwinConfigurations = {
      "macbook" = mkDarwin {
        username = "alex"; # Example mac user
        profile = "dev";
      };
    };

    # --- Shared package/devshell outputs for non-NixOS usage ---
    packages = nixpkgs.lib.genAttrs systems (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        sets = packageSetsFor system;
      in nixpkgs.lib.mapAttrs (name: paths:
        pkgs.buildEnv {
          name = "${name}-packages";
          paths = paths;
        }
      ) sets.profiles);

    devShells = nixpkgs.lib.genAttrs systems (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        sets = packageSetsFor system;
        mkShellFor = paths: pkgs.mkShell { packages = paths; };
        shellProfiles = {
          dev = sets.profiles.dev;
          desktop = sets.profiles.desktop;
        };
      in nixpkgs.lib.mapAttrs (name: paths: mkShellFor paths) shellProfiles // {
        default = mkShellFor sets.profiles.dev;
      });
  };
}
