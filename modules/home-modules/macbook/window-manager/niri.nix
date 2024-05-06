{ config, inputs, pkgs, ... }:

{
  programs.niri = {
    settings = {
      input = {
        focus-follows-mouse = true;
        keyboard.xkb = {
          layout = "us";
          options = "ctrl:swapcaps";
        };
        touchpad = {
          natural-scroll = true;
          dwt = true;
          click-method = "clickfinger";
          tap = true;
        };
      };

      outputs = {
        "eDP-1" = {
          scale = 1.6;
          position = {
            x = 1280;
            y = 360;
          };
        };
        "DP-4" = {
          scale = 1.6;
          position = {
            x = 0;
            y = 0;
          };
        };
      };

      layout = {
        center-focused-column = "never";
	default-column-width = { proportion = 1. / 2.; };
        preset-column-widths = [
          { proportion = 1. / 3.; }
          { proportion = 1. / 2.; }
          { proportion = 2. / 3.; }
        ];
      };

      prefer-no-csd = true;

      window-rules = [{ draw-border-with-background = false; }];

      spawn-at-startup = [
        { command = [ "waybar" ]; }
        { command = [ "wezterm" ]; }
        { command = [ "keepassxc" ]; }
        { command = [ "fcitx5 -r -d" ]; }
        { command = [ "ags" ]; }
      ];

      binds = with config.lib.niri.actions; {
        "Alt+Q".action = close-window;
        "Alt+Ctrl+T".action = spawn [ "wezterm" "-e" "fish" ];
        "Alt+Ctrl+T".cooldown-ms = 500;
        "Alt+Space".action = spawn [ "rofi" "-show" "combi" ];

        "Super+WheelScrollDown".action = focus-workspace-down;
        "Super+WheelScrollDown".cooldown-ms = 500;
        "Super+WheelScrollUp".action = focus-workspace-up;
        "Super+WheelScrollUp".cooldown-ms = 500;
        "Super+WheelScrollRight".action = focus-column-right;
        "Super+WheelScrollLeft".action = focus-column-left;

        "Super+H".action = focus-column-left;
        "Super+L".action = focus-column-right;
        "Super+J".action = focus-workspace-down;
        "Super+K".action = focus-workspace-up;
        "Super+Left".action = focus-column-left;
        "Super+Right".action = focus-column-right;
        "Super+Down".action = focus-window-down;
        "Super+Up".action = focus-window-up;

    "Super+Ctrl+Left".action = move-column-left;
    "Super+Ctrl+Down".action = move-window-down;
    "Super+Ctrl+Up".action = move-window-up;
    "Super+Ctrl+Right".action = move-column-right;
    "Super+Ctrl+H".action = move-column-left;
    "Super+Ctrl+J".action = move-window-down;
    "Super+Ctrl+K".action = move-window-up;
    "Super+Ctrl+L".action = move-column-right;

        "Super+U".action = move-workspace-down;
        "Super+I".action = move-workspace-up;

        "Super+Minus".action = set-column-width "-10%";
        "Super+Equal".action = set-column-width "+10%";
        "Super+Shift+Minus".action = set-window-height "-10%";
        "Super+Shift+Equal".action = set-window-height "+10%";

        "Alt+Shift+Left".action = focus-monitor-left;
        "Alt+Shift+Down".action = focus-monitor-down;
        "Alt+Shift+Up".action = focus-monitor-up;
        "Alt+Shift+Right".action = focus-monitor-right;
        "Alt+Shift+H".action = focus-monitor-left;
        "Alt+Shift+J".action = focus-monitor-down;
        "Alt+Shift+K".action = focus-monitor-up;
        "Alt+Shift+L".action = focus-monitor-right;

        "Alt+Shift+Ctrl+Left".action = move-column-to-monitor-left;
        "Alt+Shift+Ctrl+Down".action = move-column-to-monitor-down;
        "Alt+Shift+Ctrl+Up".action = move-column-to-monitor-up;
        "Alt+Shift+Ctrl+Right".action = move-column-to-monitor-right;
        "Alt+Shift+Ctrl+H".action = move-column-to-monitor-left;
        "Alt+Shift+Ctrl+J".action = move-column-to-monitor-down;
        "Alt+Shift+Ctrl+K".action = move-column-to-monitor-up;
        "Alt+Shift+Ctrl+L".action = move-column-to-monitor-right;

        "Super+R".action = switch-preset-column-width;
        "Super+F".action = maximize-column;
        "Super+Shift+F".action = fullscreen-window;
        "Super+C".action = center-column;
      };
    };
  };
}
