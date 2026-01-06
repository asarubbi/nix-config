{ pkgs, ... }: {
  programs.tmux = {
    enable = true;
    # Matches your 'set -g prefix C-s'
    prefix = "C-s"; 
    # Matches your 'set -g mouse on'
    mouse = true;
    # Matches your 'setw -g mode-keys vi'
    keyMode = "vi";
    # Matches your 'set-option -g status-position top'
    statusPosition = "top";
    
    plugins = with pkgs.tmuxPlugins; [
      sensible
      vim-tmux-navigator
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavor "mocha"
          set -g @catppuccin_window_status_style "rounded"
        '';
      }
    ];

    extraConfig = ''
      # Matches your 'unbind r' and 'bind r'
      unbind r
      bind r source-file ~/.config/tmux/tmux.conf

      # Manual pane navigation keys
      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R

      # Status bar preferences
      set -g status off
      set -g status-right-length 100
      set -g status-left-length 100
      set -g status-left ""
      set -g status-right "[#{pane_path}] [#W]"

      # Vi-style copy/paste logic
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      
      # Conditional yank: xclip for Linux, pbcopy for Mac
      bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "${if pkgs.stdenv.isLinux then "xclip -selection clipboard -i" else "pbcopy"}"
    '';
  };

  # Ensure xclip is installed on Linux for the copy command to work
  home.packages = with pkgs; if stdenv.isLinux then [ xclip ] else [];
}
