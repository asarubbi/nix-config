{
  description = "Portable dev shell for macOS/Linux/WSL";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      gen = nixpkgs.lib.genAttrs systems;
      mkPkgs = system: import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      mkPortableCtx = system:
        let
          pkgs = mkPkgs system;
          sets = import ../modules/common/packages.nix { pkgs = pkgs; };
        in {
          inherit pkgs;
          portable = sets.profiles.portable;
        };
    in {
      packages = gen (system:
        let
          ctx = mkPortableCtx system;
        in {
          portable = ctx.pkgs.buildEnv {
            name = "portable-packages";
            paths = ctx.portable;
          };
          default = ctx.pkgs.buildEnv {
            name = "portable-packages";
            paths = ctx.portable;
          };
        });

      devShells = gen (system:
        let
          ctx = mkPortableCtx system;
        in {
          portable = ctx.pkgs.mkShell { packages = ctx.portable; };
          default = ctx.pkgs.mkShell { packages = ctx.portable; };
        });
    };
}
