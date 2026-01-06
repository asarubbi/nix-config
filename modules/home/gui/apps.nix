{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Browsers
    brave
    librewolf
    
    # Media
    spotify
    vlc
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
    mcomix
    keymapp
  ];
}
