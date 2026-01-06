{ username, ... }: {
  home.username = username;
  # home.homeDirectory is automatically set by the NixOS module
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;
}
