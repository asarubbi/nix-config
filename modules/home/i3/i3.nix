{ config, pkgs, lib, osConfig, ... }:

let
  dotfilesDir = "${config.home.homeDirectory}/nix-config";
  host = osConfig.networking.hostName;
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

  # Symlink the base config
  xdg.configFile."i3/config.base".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/modules/home/i3/i3-config/config.base";

  # Symlink the host-specific config to the main config file
  # This relies on the file naming convention: config.<hostname>
  xdg.configFile."i3/config".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/modules/home/i3/i3-config/config.${host}";

  # Symlink other i3 resources (scripts, etc.)
  xdg.configFile."i3/scripts".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/modules/home/i3/i3-config/scripts";
  xdg.configFile."i3/i3blocks.conf".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/modules/home/i3/i3-config/i3blocks.conf";
  xdg.configFile."i3/keybindings".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/modules/home/i3/i3-config/keybindings";
}
