{ pkgs, ... }: {
  imports = [
    ./kitty.nix
  ];
  
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
  ];
}
