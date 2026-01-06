{ pkgs, ... }: {
  programs.tmux = {
    enable = true;
    prefix = "C-s"; 
    mouse = true;
    keyMode = "vi";
    
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
      # FIX: Move status-position here because HM doesn't have a native option for it
      set-option -g status-position top

      unbind r
      bind r source-file ~/.config/tmux/tmux.conf

      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R

      set -g status off
      set -g status-right-length 100
      set -g status-left-length 100
      set -g status-left ""
      set -g status-right "[#{pane_path}] [#W]"

      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "${if pkgs.stdenv.isLinux then "xclip -selection clipboard -i" else "pbcopy"}"
    '';
  };

  home.packages = with pkgs; if stdenv.isLinux then [ xclip ] else [];
}
