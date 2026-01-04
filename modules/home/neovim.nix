{ config, pkgs, ... }: 
let
  dotfilesDir = "${config.home.homeDirectory}/nix-config";
in 

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;

    extraPackages = with pkgs; [

      ripgrep
      fd
      lua-language-server

      gcc 
      gnumake

      xclip

      tree-sitter
      curl

    ];
  };

  xdg.configFile.nvim.source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/modules/home/nvim-config";

}
