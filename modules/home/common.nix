{ pkgs, username, homeDirectory, ... }: {
  
  imports = [
    ./kitty.nix
    ./neovim.nix
    ./zsh.nix
  ];
  
  fonts.fontconfig.enable = true;

  home.username = username;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "25.11";
  home.packages = with pkgs; [
    git
    btop
    tmux
    fzf
    ranger
    ncdu
    wget
    unzip
    lazygit
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
  ];


}
