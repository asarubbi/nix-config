{
  description = "NixOS Flake - Multi-System Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, nix-darwin, ... }@inputs: 
  let 
    # --- Helper Functions ---

    # Helper for creating NixOS configurations
    mkNixos = { hostname, username, system ? "x86_64-linux", modules ? [] }: 
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/${hostname}/configuration.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              inherit inputs;
              inherit username;
              homeDirectory = "/home/${username}";
            };
            home-manager.users.${username} = {
              imports = [ 
                ./modules/home/core.nix
                ./modules/home/cli/default.nix
                ./modules/home/gui/default.nix
              ];
            };
          }
        ] ++ modules;
      };

    # Helper for creating macOS (Darwin) configurations
    mkDarwin = { username, system ? "aarch64-darwin", modules ? [] }:
      nix-darwin.lib.darwinSystem {
        inherit system;
        modules = [
          ./modules/darwin/base.nix
          home-manager.darwinModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              inherit inputs;
              inherit username;
              homeDirectory = "/Users/${username}";
            };
            home-manager.users.${username} = {
              imports = [
                ./modules/home/core.nix
                ./modules/home/cli/default.nix
                ./modules/home/gui/default.nix 
              ];
            };
          }
        ] ++ modules;
      };

    # Helper for creating Standalone Home Manager configurations
    mkHome = { username, sys ? "x86_64-linux", modules ? [] }: 
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${sys};
        extraSpecialArgs = { 
          inherit inputs; 
          inherit username;
          homeDirectory = "/home/${username}";
        };
        modules = [
          ./modules/home/core.nix
          ./modules/home/cli/default.nix
        ] ++ modules;
      };

  in { 
    
    # --- NixOS Hosts ---
    nixosConfigurations = {
      
      # PC0: Base Plasma
      pc0 = mkNixos {
        hostname = "pc0";
        username = "adsbvm";
        modules = [ ./modules/nixos/plasma6.nix ];
      };

      # PC1: i3 Window Manager
      pc1 = mkNixos {
        hostname = "pc0"; # Reusing pc0 hardware config for demo
        username = "adsbvm";
        modules = [ ./modules/nixos/i3-wm.nix ];
      };

      # PC2: GNOME
      pc2 = mkNixos {
        hostname = "pc0"; # Reusing pc0 hardware config for demo
        username = "otheruser"; # Example of different user
        modules = [ ./modules/nixos/gnome.nix ];
      };
    };

    # --- macOS Hosts ---
    darwinConfigurations = {
      "macbook" = mkDarwin {
        username = "alex"; # Example mac user
      };
    };

    # --- Standalone Home Manager ---
    homeConfigurations = {
      "mintuser" = mkHome {
        username = "mintuser";
        sys = "x86_64-linux";
        modules = [ ./modules/home/gui/default.nix ];
      };
    };

  };
}
