{ config, pkgs, ... }:

let
  dotfilesDir = "${config.home.homeDirectory}/nix-config";
  rofiConfigDir = "${dotfilesDir}/modules/home/i3/rofi-config";
  rofiThemesDir = "${dotfilesDir}/modules/home/i3/rofi-themes";
in

{
  home.packages = with pkgs; [
    (rofi.override {
      plugins = [
        rofi-emoji
        rofi-calc
        rofi-pulse-select
      ];
    })
  ];

  programs.rofi = {
    enable = true;
    theme = "rounded-nord-dark"; # Set default theme

    # extraThemes allows us to add custom themes (like power-profiles.rasi)
    # The key is the theme name, and the value is the content.
    extraThemes = {
      # The base theme
      "rounded-nord-dark" = {
        # Assuming rounded-nord-dark.rasi imports its template
        "rounded-nord-dark.rasi" = builtins.readFile "${rofiThemesDir}/rounded-nord-dark.rasi";
        "template/rounded-template.rasi" = builtins.readFile "${rofiThemesDir}/template/rounded-template.rasi";
      };

      # Specific Rofi mode themes
      "power-profiles" = builtins.readFile "${rofiConfigDir}/power-profiles.rasi";
      "powermenu" = builtins.readFile "${rofiConfigDir}/powermenu.rasi";
      "rofidmenu" = builtins.readFile "${rofiConfigDir}/rofidmenu.rasi";
      "rofikeyhint" = builtins.readFile "${rofiConfigDir}/rofikeyhint.rasi";
    };

    # Any extra configuration for programs.rofi
    # This might be needed if you had configurations outside of theme files.
    # extraConfig = {};
  };

  # Remove the explicit home.file entries as extraThemes now handles them
  # No longer need xdg.configFile for rofi-config, as extraThemes handles the .rasi files.
}
