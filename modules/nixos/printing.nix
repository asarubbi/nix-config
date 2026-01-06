{ pkgs, ... }: {
  services.printing.enable = true;
  services.printing.browsed.enable = false;
  services.printing.drivers = [
    pkgs.epson-escpr
    pkgs.epson-escpr2
    pkgs.brlaser
    pkgs.brgenml1lpr
    pkgs.brgenml1cupswrapper
  ];
  
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
  services.avahi.openFirewall = true;
  
  environment.systemPackages = [ pkgs.system-config-printer ];
}
