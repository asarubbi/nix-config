{ config, pkgs, ... }: # Added config to arguments

let
  dotfilesDir = "${config.home.homeDirectory}/nix-config";
in

{
  programs.rofi = {
    enable = true;
    # We don't set a global theme here because we use multiple per-mode themes.
    # The default config.rasi will be generated, but specific launches will override it.
  };

  # Direct symlink to allow editing rofi configs in place
  xdg.configFile."rofi".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/modules/home/i3/rofi-config";

  # Install custom Rofi themes to ~/.local/share/rofi/themes/
  home.file.".local/share/rofi/themes/rounded-nord-dark.rasi".source = "${dotfilesDir}/modules/home/i3/rofi-themes/rounded-nord-dark.rasi";
  home.file.".local/share/rofi/themes/template/rounded-template.rasi".source = "${dotfilesDir}/modules/home/i3/rofi-themes/template/rounded-template.rasi";
}