{ pkgs, ... }: {
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 14;
    };
    settings = {
      scrollback_lines = 100000;
      enable_audio_bell = false;
      update_check_interval = 0;
      macos_option_as_alt = "both";
      background_opacity = 0.5;
      confirm_os_window_close = 0;
    };
    shellIntegration.enableZshIntegration = true;
  };
  home.sessionVariables = {
    TERMINAL = "kitty";
  };
}
