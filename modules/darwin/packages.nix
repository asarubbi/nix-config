{ pkgs, profilePackages ? [], profileFonts ? [], ... }:
{
  environment.systemPackages = profilePackages;

  # Expose fonts for terminals/editors; nix-darwin installs them into the system font directory.
  fonts.fontDir.enable = true;
  fonts.fonts = profileFonts;
}
