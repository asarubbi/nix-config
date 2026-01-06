{ pkgs, ... }: {
  imports = [
    ./neovim.nix
    ./tmux.nix
    ./zsh.nix
  ];

  home.packages = with pkgs; [
    git
    gh
    btop
    fzf
    ranger
    ncdu
    wget
    unzip
    lazygit
    trash-cli
    tree
  ];
}
