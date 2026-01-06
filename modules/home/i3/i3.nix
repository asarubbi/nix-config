{ config, pkgs, ... }:

let
  dotfilesDir = "${config.home.homeDirectory}/nix-config";
in
{
  # We assume i3 is installed system-wide via NixOS module (modules/nixos/i3-wm.nix)
  # But we can add extra user-specific packages here if needed.
  home.packages = with pkgs; [
    # Add any i3 specific user packages here if they aren't in the system config
    # e.g. autotiling, specific applets
    autotiling
    i3status
    i3blocks
    networkmanagerapplet
    # Screenshot tools are in gui/core.nix
  ];

  # Symlink the i3 config directory
  xdg.configFile."i3".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/modules/home/i3/i3-config";

  # Ensure scripts are executable (Git tracks permissions, but good to be sure if copied)
  # We don't strictly need to do anything if the source files are executable.
}
