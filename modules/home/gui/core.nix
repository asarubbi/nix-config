{ pkgs, ... }: {
  imports = [
    ./kitty.nix
    ./theme.nix
  ];
  
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    # Fonts
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
    nerd-fonts.fira-code
    nerd-fonts.hack
    nerd-fonts.droid-sans-mono
    nerd-fonts.noto
    nerd-fonts.ubuntu
    font-awesome
    
    # Core Media/System Tools
    pavucontrol # Audio control
    feh         # Wallpaper/Image viewer
    flameshot   # Screenshots
    playerctl   # Media control
    
    # Terminals
    alacritty
    
    # System / File Mgmt
    nemo-with-extensions
    xscreensaver
    xorg.xkill
  ];
}
