{ config, pkgs, ... }: # Added config to arguments

let
  dotfilesDir = "${config.home.homeDirectory}/nix-config";
in

{
  # We manage configuration manually via symlink, so we don't use the module's config generation.
  # We just install the package.
  home.packages = [ pkgs.rofi ];

  # Direct symlink to allow editing rofi configs in place
  xdg.configFile."rofi".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/modules/home/i3/rofi-config";

  # Install custom Rofi themes to ~/.local/share/rofi/themes/
  home.file.".local/share/rofi/themes/rounded-nord-dark.rasi".source = "${dotfilesDir}/modules/home/i3/rofi-themes/rounded-nord-dark.rasi";
  home.file.".local/share/rofi/themes/template/rounded-template.rasi".source = "${dotfilesDir}/modules/home/i3/rofi-themes/template/rounded-template.rasi";
}