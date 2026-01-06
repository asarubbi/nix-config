{ pkgs, ... }: {
  imports = [
    ./neovim.nix
    ./tmux.nix
    ./zsh.nix
    ./ranger.nix
  ];

  home.packages = with pkgs; [
    # Core
    git
    gh
    lazygit
    stow
    
    # Utilities
    btop
    fzf
    ranger
    ncdu
    wget
    unzip
    zip
    trash-cli
    tree
    ripgrep
    fd
    jq
    tldr
    xclip
    
    # Dev / Scripts from original
    python3
    gcc
    gnumake
    libnotify
    lm_sensors
    man
    
    # Missing from original
    superfile
    vifm
    gemini-cli
    
    # Fun/Misc
    neofetch
    cmatrix
    asciinema

    zsh
  ];
}
