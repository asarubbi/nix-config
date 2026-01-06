{ pkgs, ... }: {
  
  environment.systemPackages =
    [ pkgs.vim
    ];

  services.nix-daemon.enable = true;
  nix.settings.experimental-features = "nix-command flakes";

  programs.zsh.enable = true; 

  system.stateVersion = 5;
  
  security.pam.enableSudoTouchIdAuth = true;
}
