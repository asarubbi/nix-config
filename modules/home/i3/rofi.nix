{ pkgs, ... }:

{
  programs.rofi = {
    enable = true;
  };

  # Source all rofi configuration files from the directory
  xdg.configFile."rofi" = {
    source = ./rofi-config;
    recursive = true;
  };
}