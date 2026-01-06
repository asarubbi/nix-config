{ pkgs, ... }: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    defaultKeymap = "viins";

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "amuse";
    };

    history = {
      size = 100000;
      ignoreSpace = true;
    };

    shellAliases = {
      ll = "ls -altr --color=auto";
      ".." = "cd ..";
      v = "nvim";
      g = "git";
      del = "rmtrash";
      trash = "rmtrash";
      vi = "nvim";
      vim = "nvim";
      cd = "z";
      jrnl = "jrnl";
    };

    initContent = ''
      eval "$(zoxide init zsh)"
      
      export GTK_THEME=Palenight
      export RANGER_LOAD_DEFAULT_RC=FALSE
      export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1
      export NIXPKGS_ALLOW_UNFREE=1
      export VISUAL=nvim
      export EDITOR=nvim

      bindkey -v
      export KEYTIMEOUT=1
    '';
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      line_break.disable = true;
    };
  };


  home.packages = with pkgs; [
    zsh
    zoxide
    fzf
  ];
}
