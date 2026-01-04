{
  description = "NixOS Flake - PC0 VM";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager,  ... }@inputs: { 
    nixosConfigurations.pc0 = nixpkgs.lib.nixosSystem {
      system = { inherit inputs;  };
      specialArgs = { inherit inputs;  };
      modules = [
        ./hosts/pc0/configuration.nix
        ./system/plasma6.nix
        home-manager.nixosModules.home-manager {
          home-manager.extraSpecialArgs = {
            username = "adsbvm";
            homeDirectory = "/home/adsbvm";
          };
          home-manager.users.adsbvm = import ./modules/home/common.nix;
        }
      ];
    };

  
    nixosConfigurations.pc1 = nixpkgs.lib.nixosSystem {
      system = { inherit inputs;  };
      specialArgs = { inherit inputs;  };
      modules = [
        ./hosts/pc0/configuration.nix
        ./system/i3-wm.nix
        home-manager.nixosModules.home-manager {
          home-manager.extraSpecialArgs = {
            username = "adsbvm";
            homeDirectory = "/home/adsbvm";
          };
          home-manager.users.adsbvm = import ./modules/home/common.nix;
        }
      ];
    };

    nixosConfigurations.pc2 = nixpkgs.lib.nixosSystem {
      system = { inherit inputs;  };
      specialArgs = { inherit inputs;  };
      modules = [
        ./hosts/pc0/configuration.nix
        ./system/gnome.nix
        home-manager.nixosModules.home-manager {
          home-manager.extraSpecialArgs = {
            username = "adsbvm";
            homeDirectory = "/home/adsbvm";
          };
          home-manager.users.adsbvm = import ./modules/home/common.nix;
        }
      ];
    };
  };
}
