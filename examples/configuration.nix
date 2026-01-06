# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, ... }:
let
  unstableTarball =
    fetchTarball
      https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz;

  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz";
in
{
  imports =
    [ 
      (import "${home-manager}/nixos")
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./nix-alien.nix
      ./local-hardware.nix
      ./display-manager.nix
    ];


  home-manager.useGlobalPkgs = true;
  home-manager.backupFileExtension = "backup3";

  home-manager.users.asarubbi = {


    /* The home.stateVersion option does not have a default and must be set */
    home.stateVersion = "25.05";
    /* Here goes the rest of your home-manager config, e.g. home.packages = [ pkgs.foo ]; */
    programs.rofi = {
      enable = true;
      theme = "rounded-nord-dark";
      plugins = [
        pkgs.rofi-emoji
        pkgs.rofi-calc
        pkgs.rofi-pulse-select
      ];
    };
    home.pointerCursor = {
      name = "capitaine-cursors";
      package = pkgs.capitaine-cursors;
      size = 40;
    };

    gtk = {
      enable = true;
      theme = {
        name = "Palenight";
        package = pkgs.palenight-theme;

      };
      cursorTheme = {
        name = "capitaine-cursors";
        package = pkgs.capitaine-cursors;
        size = 40;
      };
    };


    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      oh-my-zsh = {
        enable = true;
        plugins = [ "git" ];
        theme = "amuse";
      };

      shellAliases = {
        ll = "ls -altr --color=auto";
        del = "rmtrash";
        trash = "rmtrash";
        vi = "nvim";
        cd = "z";
        vim = "nvim";
        jrnl = " jrnl";
      };
      history = {
        size = 100000;
      };
      initContent = ''
        setopt HIST_IGNORE_SPACE
        
        export GTK_THEME=Palenight
        export RANGER_LOAD_DEFAULT_RC=FALSE
        export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1
        export NIXPKGS_ALLOW_UNFREE=1
        export VISUAL=nvim
        export EDITOR=nvim
        
        eval "$(zoxide init zsh)"
        eval "$(starship init zsh)"
        
        set -o vi

      '';
    };
  
  };

  nixpkgs.config = {
    packageOverrides = pkgs: with pkgs; {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };



  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  networking.extraHosts =
  ''
    127.0.0.1 wpad
    10.17.18.1 hogwarts
    10.17.18.30 hogsmeade
  '';  

  boot.kernelModules = [ "corsair-psu" ];


# Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  hardware.graphics = {
   enable = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  #enable gnome keyring
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.asarubbi.enableGnomeKeyring = true;

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh; #not a democracy.

  environment.pathsToLink = [ "/libexec" ];

  programs.dconf.enable = true;


  hardware.nvidia = {
   modesetting.enable = true;
   powerManagement.enable = true;
   powerManagement.finegrained = false;
   open = false;
   nvidiaSettings = true;
   package = config.boot.kernelPackages.nvidiaPackages.latest;
  };


  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
 };



fonts.packages = with pkgs; [
  nerd-fonts.fira-code
  nerd-fonts.droid-sans-mono
  nerd-fonts.noto
  nerd-fonts.hack
  nerd-fonts.ubuntu
  nerd-fonts.symbols-only
  font-awesome
];

  # Configure keymap in X11

  # Allow appimages to run
  programs.appimage.binfmt = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.asarubbi = {
    isNormalUser = true;
    description = "Alberto D. Sarubbi";
    extraGroups = [ "networkmanager" "wheel" "input" "disk" "libvirtd" "docker" "audio" "plugdev" "storage" ];
    packages = with pkgs; [
      #A
      asciinema
      alacritty
      #B
      btop
      #C
      codex
      lazygit
      dunst
      brave
      gh
      git
      stow
      tmux
      rofi
      rofi-power-menu
      numlockx
      dex
      #F
      feh
      fzf
      zoxide
      #bottles moving to the flatpak version
      bluez
      docker-compose
      distrobox
      fd
      flameshot
      #g
      gemini-cli
      gtk3
      glib
      xdg-utils
       gamemode
       gcc
       gimp
       github-desktop
       gnumake
       gnumake
       gpu-screen-recorder
       gpu-screen-recorder-gtk
       htop
        #J
       jq
       jrnl
       kitty
       #L
       lm_sensors
       librewolf
       libgcc
       libqalculate
       lutris
       lxappearance
       libnotify
       keymapp
       marksman
       mc
       mangohud
       mlocate
       mcomix
       #N
       ncdu
       nemo-with-extensions
       neofetch
       unstable.neovim
       nodejs
       #o
       obsidian
       OVMFFull
       #p
       pandoc
       pavucontrol
       plantuml
       podman-compose
       playerctl
       protonup-qt
       python3
       palenight-theme
       #q
       qemu
       qalculate-qt
       ranger
       remmina
       ripgrep
       rmtrash
       rar
       rofi-calc
       rofi-emoji
       #s
       seahorse
       shotcut
       spacx-gtk-theme
       spotify
       systemd
       starship
       system-config-printer
       superfile
       tldr
       tree
      #xfce.thunar
       unrar
       unzip
       #V
       vbam
       vim
       vifm
       #vimPlugins.markdown-preview-nvim
       virt-manager
       #ventoy
       vlc
       webcamoid
       wget
       winetricks
       wineWowPackages.stable
       virtio-win
       win-spice
       xorg.xkill
       xsel
       xscreensaver
       linuxKernel.packages.linux_6_6.xpadneo
       yarn
      #X
      xclip
      #Z
      zip
    ];
  };

  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  programs.nix-ld.enable = true;
  # custom packages


  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

  services.blueman.enable = true;


  #sound.mediaKeys.enable = true;

#  programs.autojump.enable = true;
  programs.starship.enable = true;
  programs.gamemode.enable = true;




 # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.browsed.enable = false; # this is to prevent the printer being added automatically
  services.printing.drivers = [
    pkgs.epson-escpr
    pkgs.epson-escpr2
    pkgs.brlaser
    pkgs.brgenml1lpr
    pkgs.brgenml1cupswrapper
  ];
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
  services.avahi.openFirewall = true; # for a WiFi printer
  

  services.flatpak.enable = true;
  xdg.portal = {
    config = {
      common = {
        default = [ "gtk" ];
      };
    };
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    xdgOpenUsePortal = true;
  };


  services.picom.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  #
  ];


  # Enable sound with pipewire.
  #sound.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  location.provider = "manual";
  location.longitude = -81.656761;
  location.latitude = 30.325970;
  # All values except 'enable' are optional.
  services.redshift = {
    enable = true;
    brightness = {
      # Note the string values below.
      day = "1";
      night = "1";
    };
    temperature = {
      day = 4500;
      night = 3700;
    };
  };

virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
  virtualisation.podman.enable = true;
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        swtpm.enable = true;
      };
    };
    spiceUSBRedirection.enable = true;
  };
  services.spice-vdagentd.enable = true;

programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    # Certain features, including CLI integration and system authentication support,
    # require enabling PolKit integration on some desktop environments (e.g. Plasma).
    polkitPolicyOwners = [ "asarubbi" ];
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 15d";
  };


  system.copySystemConfiguration = true;
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;
  system.autoUpgrade.channel = "https://channels.nixos.org/nixos-25.11";



  services.udev.extraRules = ''
# Rules for Oryx web flashing and live training
  KERNEL=="hidraw*", ATTRS{idVendor}=="16c0", MODE="0664", GROUP="plugdev"
  KERNEL=="hidraw*", ATTRS{idVendor}=="3297", MODE="0664", GROUP="plugdev"

# Legacy rules for live training over webusb (Not needed for firmware v21+)
    # Rule for all ZSA keyboards
    SUBSYSTEM=="usb", ATTR{idVendor}=="3297", GROUP="plugdev"
    # Rule for the Moonlander
    SUBSYSTEM=="usb", ATTR{idVendor}=="3297", ATTR{idProduct}=="1969", GROUP="plugdev"
    # Rule for the Ergodox EZ
    SUBSYSTEM=="usb", ATTR{idVendor}=="feed", ATTR{idProduct}=="1307", GROUP="plugdev"
    # Rule for the Planck EZ
    SUBSYSTEM=="usb", ATTR{idVendor}=="feed", ATTR{idProduct}=="6060", GROUP="plugdev"

# Wally Flashing rules for the Ergodox EZ
  ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", ENV{ID_MM_DEVICE_IGNORE}="1"
  ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789A]?", ENV{MTP_NO_PROBE}="1"
  SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789ABCD]?", MODE:="0666"
  KERNEL=="ttyACM*", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", MODE:="0666"

# Keymapp / Wally Flashing rules for the Moonlander and Planck EZ
  SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", MODE:="0666", SYMLINK+="stm32_dfu"
# Keymapp Flashing rules for the Voyager
  SUBSYSTEMS=="usb", ATTRS{idVendor}=="3297", MODE:="0666", SYMLINK+="ignition_dfu"
  '';


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
