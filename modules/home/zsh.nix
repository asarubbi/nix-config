{ pkgs, ... }: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    defaultKeymap = "viins";

    shellAliases = {
      ll = "ls -altr --color=auto";
      ".." = "cd ..";
      v = "nvim";
      g = "git";
    };

    initContent = ''
      eval "$(zoxide init zsh)"

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
    zoxide
    fzf
  ];
}
