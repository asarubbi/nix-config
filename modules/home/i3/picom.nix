{ pkgs, ... }:

{
  services.picom = {
    enable = true;
    backend = "xrender";
    vSync = true;
    
    # Shadows
    shadow = true;
    # Note: shadowOffsets is NOT a valid top-level Home Manager option.
    # We must use settings for offsets and radius.
    
    # Fading
    fade = true;
    fadeSteps = [ 0.03 0.03 ];
    
    # Opacity
    inactiveOpacity = 0.95;
    
    # Excludes
    shadowExclude = [
      "name = 'Notification'"
      "class_g = 'Conky'"
      "class_g ?= 'Notify-osd'"
      "class_g = 'Cairo-clock'"
      "_GTK_FRAME_EXTENTS@:c"
    ];

    settings = {
      # Shadows - offsets and radius must be here
      shadow-radius = 7;
      shadow-offset-x = -7;
      shadow-offset-y = -7;
      
      # Transparency / Opacity
      frame-opacity = 0.9;
      inactive-opacity-override = false;
      focus-exclude = [ "class_g = 'Cairo-clock'" ];

      # Corners
      corner-radius = 0;
      rounded-corners-exclude = [
        "window_type = 'dock'"
        "window_type = 'desktop'"
      ];

      # Background-Blurring
      blur-kern = "3x3box";
      blur-background-exclude = [
        "window_type = 'dock'"
        "window_type = 'desktop'"
        "_GTK_FRAME_EXTENTS@:c"
      ];

      # General Settings
      dithered-present = false;
      mark-wmwin-focused = true;
      mark-ovredir-focused = true;
      detect-rounded-corners = true;
      detect-client-opacity = true;
      detect-transient = true;
      
      glx-no-stencil = true;
      use-damage = true;
      
      log-level = "warn";
      
      wintypes = {
        tooltip = { fade = true; shadow = true; opacity = 0.75; focus = true; full-shadow = false; };
        dock = { shadow = false; clip-shadow-above = true; };
        dnd = { shadow = false; };
        popup_menu = { opacity = 0.8; };
        dropdown_menu = { opacity = 0.8; };
      };
    };
  };
}