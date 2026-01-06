{ config, pkgs, ... }:

let
  dotfilesDir = "${config.home.homeDirectory}/nix-config";
  rofiConfigDir = "${dotfilesDir}/modules/home/i3/rofi-config";
  rofiThemesDir = "${dotfilesDir}/modules/home/i3/rofi-themes";
in

{
  programs.rofi = {
    enable = true;
    theme = "rounded-nord-dark"; 
    plugins = with pkgs; [
      rofi-emoji
      rofi-calc
      rofi-pulse-select
    ];
  };

  # Install Rofi themes and custom configs into ~/.local/share/rofi/themes
  # Rofi looks here for themes, so our custom .rasi files will be found by name.
  
  # Base Theme
  xdg.dataFile."rofi/themes/rounded-nord-dark.rasi".source = "${rofiThemesDir}/rounded-nord-dark.rasi";
  xdg.dataFile."rofi/themes/template/rounded-template.rasi".source = "${rofiThemesDir}/template/rounded-template.rasi";

  # Custom "Themes" (Modes)
  # These are technically config files, but since we treat them as themes to be loaded with -theme,
  # putting them in the themes directory is the cleanest way to make them discoverable without full path.
  xdg.dataFile."rofi/themes/power-profiles.rasi".source = "${rofiConfigDir}/power-profiles.rasi";
  xdg.dataFile."rofi/themes/powermenu.rasi".source = "${rofiConfigDir}/powermenu.rasi";
  xdg.dataFile."rofi/themes/rofidmenu.rasi".source = "${rofiConfigDir}/rofidmenu.rasi";
  xdg.dataFile."rofi/themes/rofikeyhint.rasi".source = "${rofiConfigDir}/rofikeyhint.rasi";
}
