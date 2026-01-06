{ pkgs, profilePackages ? [], profileFonts ? [], ... }:
{
  environment.systemPackages = profilePackages;
  fonts.packages = profileFonts;
  fonts.fontconfig.enable = true;
}
