{ pkgs, ... }: {
  gtk = {
    enable = true;
    theme = {
      name = "Palenight";
      package = pkgs.palenight-theme;
    };
    cursorTheme = {
      name = "capitaine-cursors";
      package = pkgs.capitaine-cursors;
      size = 40;
    };
  };

  home.pointerCursor = {
    name = "capitaine-cursors";
    package = pkgs.capitaine-cursors;
    size = 40;
    gtk.enable = true;
  };

  programs.rofi = {
    enable = true;
    theme = "rounded-nord-dark";
    plugins = with pkgs; [
      rofi-emoji
      rofi-calc
      rofi-pulse-select
    ];
  };

  # Extra theming / appearance packages
  home.packages = with pkgs; [
    dunst
    lxappearance
    papirus-icon-theme
    spacx-gtk-theme
    rofi-power-menu
  ];
}
