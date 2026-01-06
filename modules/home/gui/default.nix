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

    # Browsers
    brave
    librewolf
    
    # Media
    spotify
    vlc
    pavucontrol
    feh
    flameshot
    playerctl
    webcamoid
    gpu-screen-recorder
    gpu-screen-recorder-gtk
    
    # Productivity
    obsidian
    
    # Graphics / Tools
    gimp
    inkscape
    shotcut
    remmina
    seahorse
    
    # Terminals
    alacritty
    
    # System / File Mgmt
    nemo-with-extensions
    xscreensaver
    xorg.xkill
    mcomix
    keymapp
  ];
}
