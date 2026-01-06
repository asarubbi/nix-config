{ pkgs, ... }: {

  services.xserver = {
    enable = true;
    
    desktopManager = {
      xterm.enable = false;
    };

    displayManager = {
      lightdm.enable = true;
      defaultSession = "none+i3";
    };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        i3status
        i3lock
        i3blocks
      ];
    };
  };

  # Picom (Compositor)
  services.picom = {
    enable = true;
    fade = true;
    shadow = true;
    settings = {
       blur = {
         method = "gaussian";
         size = 10;
         deviation = 5.0;
       };
    };
  };
}