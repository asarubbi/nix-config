{ pkgs }:

let
  inherit (pkgs) lib stdenv;
  isLinux = stdenv.isLinux;
  isDarwin = stdenv.isDarwin;

  cli = with pkgs; [
    git
    gh
    lazygit
    stow
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
    python3
    gcc
    gnumake
    libnotify
    lm_sensors
    man
    superfile
    vifm
    gemini-cli
    neofetch
    cmatrix
    asciinema
    zsh
    tmux
    zoxide
    starship
    kitty
    neovim
    lua-language-server
    tree-sitter
    curl
    ghostscript
    mermaid-cli
    tectonic
  ]
  ++ lib.optionals isLinux [
    xclip
  ];

  guiCore = lib.optionals isLinux (with pkgs; [
    pavucontrol
    feh
    flameshot
    playerctl
    alacritty
    nemo-with-extensions
    xscreensaver
    xorg.xkill
    rofi
    rofi-power-menu
    rofi-emoji
    rofi-calc
    rofi-pulse-select
  ]);

  guiApps = lib.optionals isLinux (with pkgs; [
    brave
    librewolf
    spotify
    vlc
    webcamoid
    gpu-screen-recorder
    gpu-screen-recorder-gtk
    obsidian
    gimp
    inkscape
    shotcut
    remmina
    seahorse
    mcomix
    keymapp
  ]);

  fonts = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
    nerd-fonts.fira-code
    nerd-fonts.hack
    nerd-fonts.droid-sans-mono
    nerd-fonts.noto
    nerd-fonts.ubuntu
    font-awesome
  ];

  i3Extras = lib.optionals isLinux (with pkgs; [
    i3
    dmenu
    autotiling
    i3status
    i3blocks
    networkmanagerapplet
  ]);
  
  gaming = lib.optionals isLinux (with pkgs; [
    bottles
    heroic
    lutris
    mangohud
    protonup-qt
    winetricks
    wineWowPackages.stable
  ]);

  virtualization = lib.optionals isLinux (with pkgs; [
    distrobox
    docker-compose
    podman-compose
    qemu
    virt-manager
    virtio-win
    win-spice
  ]);

  dev = cli;
  desktop = dev ++ guiCore ++ guiApps ++ i3Extras ++ fonts;
  titan = desktop ++ gaming ++ virtualization;
  devbox = desktop;
in {
  inherit cli dev desktop titan devbox guiCore guiApps fonts i3Extras gaming virtualization;
  profiles = {
    inherit dev desktop titan devbox;
  };
}
