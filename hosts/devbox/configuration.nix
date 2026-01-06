{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    # Minimal devbox specific modules
    # For example, if you want SSH server by default:
    # services.openssh.enable = true;
  ];

  # Basic system settings
  networking.hostName = "devbox";
  users.users.adsbvm = {
    isNormalUser = true;
    home = "/home/adsbvm";
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ];
  };
  programs.zsh.enable = true;
  
  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  system.stateVersion = "25.11"; 
}
