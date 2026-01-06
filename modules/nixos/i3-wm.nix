{ pkgs, ...}: {
  services.xserver = {
    enable = true;
    desktopManager.xterm.enable = false;

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
        picom
      ];
    };
  };
}
