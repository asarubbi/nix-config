{ config, pkgs, ... }:
let
  dotfilesDir = "${config.home.homeDirectory}/nix-config";
in
{
  programs.ranger = {
    enable = true;
    # No explicit configFile needed here, as the whole directory is symlinked and ranger looks for rc.conf by default
  };

  # Symlink the entire ranger-config directory to ~/.config/ranger
  xdg.configFile."ranger".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/modules/home/cli/ranger-config";
}
