{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      ../../modules/nixos/nvidia.nix
      ../../modules/nixos/virtualization.nix
      ../../modules/nixos/gaming.nix
      ../../modules/nixos/printing.nix
      ../../modules/nixos/1password.nix
      ../../modules/nixos/zsa-keyboards.nix
    ];

  # Mount points
  fileSystems."/mnt/gameland" = {
      device = "/dev/disk/by-uuid/f74d86ab-018e-4f80-a75e-b17733ab6496";
      fsType = "ext4";
  };

  fileSystems."/mnt/homeland" = {
    device = "/dev/disk/by-uuid/7e172fe7-3d2a-45ed-b3b0-37b666f9636f";
    fsType = "ext4";
  };

  services.xserver.displayManager.setupCommands = ''
    ${pkgs.xorg.xrandr}/bin/xrandr \
    --output HDMI-0 --mode 4096x2160 --pos 0x0 --rate 120 --primary \
    --output DP-2 --mode 2560x1440 --pos 4096x360 --rate 60 
  '';

  # Bootloader (Matched to original config)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelModules = [ "corsair-psu" ];

  networking.hostName = "DARK-PORTAL";
  networking.networkmanager.enable = true;
  networking.extraHosts = ''
    127.0.0.1 wpad
    10.17.18.1 hogwarts
    10.17.18.30 hogsmeade
  '';

  # Time and Locale
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  
  # X11 / Keymap
  services.xserver.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "altgr-intl";
  };

  # Sound
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Services & Hardware from original config
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.asarubbi.enableGnomeKeyring = true;
  
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  
  services.flatpak.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = [ "gtk" ];
  };

  # Redshift
  location.provider = "manual";
  location.longitude = -81.656761;
  location.latitude = 30.325970;
  services.redshift = {
    enable = true;
    brightness = { day = "1"; night = "1"; };
    temperature = { day = 4500; night = 3700; };
  };

  # App Support
  programs.nix-ld.enable = true;
  programs.appimage.binfmt = true;
  programs.dconf.enable = true;

  # User Account
  users.users.asarubbi = {
    isNormalUser = true;
    description = "Alberto D. Sarubbi";
    extraGroups = [ "networkmanager" "wheel" "input" "disk" "libvirtd" "docker" "audio" "plugdev" "storage" ];
    shell = pkgs.zsh;
  };
  programs.zsh.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Maintenance
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 15d";
  };

  system.stateVersion = "25.11"; # Matched to original
}
