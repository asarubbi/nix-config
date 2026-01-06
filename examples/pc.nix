{ config, lib, pkgs, ... }:

{

  networking.hostName = "DARK-PORTAL";

  fileSystems."/mnt/gameland" = {
      device = "/dev/disk/by-uuid/f74d86ab-018e-4f80-a75e-b17733ab6496";
      #options = [ "uid=1000" "gid=100" "dmask=007" "fmask=117" ];
      fsType = "ext4";
  };

  fileSystems."/mnt/homeland" = {
    device = "/dev/disk/by-uuid/7e172fe7-3d2a-45ed-b3b0-37b666f9636f";
    #options = [ "uid=1000" "gid=100" "dmask=007" "fmask=117" ];
    fsType = "ext4";
  };

  services.xserver.displayManager.setupCommands = ''
    ${pkgs.xorg.xrandr}/bin/xrandr \
    --output HDMI-0 --mode 4096x2160 --pos 0x0 --rate 120 --primary \
    --output DP-2 --mode 2560x1440 --pos 4096x360 --rate 60 
  '';
}
