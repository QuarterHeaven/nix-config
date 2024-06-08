{ inputs, config, pkgs, ... }:

{
  home.file = {
    ".config/hypr/hyprpaper.conf".source =
      "${inputs.dotfiles}/hypr/hyprpaper.conf";
    ".config/hypr/scripts".source = "${inputs.dotfiles}/hypr/scripts";
    ".config/hypr/hyprlock.conf".source =
      "${inputs.dotfiles}/hypr/hyprlock.conf";
  };

  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.package =
    inputs.hyprland.packages.${pkgs.system}.hyprland;
  wayland.windowManager.hyprland.systemd.enable = true;
  wayland.windowManager.hyprland.systemd.variables = [ "--all" ];

  imports = [
    # ./hyprland-slidr.nix
    ./hyprland-scroll.nix
  ];

  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
    "$alt" = "ALT";
    monitor = [
      "eDP-1, preferred, auto, 1.600000"
      "desc:AOC Q2701 GWRK8HA002235, preferred, 0x0, 1.25"
    ];
    bind = [
      "$mod, F, fullscreen, 0"
      "$mod, G, exec, grimblast copy area"
      "ALT CTRL, T, exec, foot"
      "ALT, E, exec, emacs"
      "ALT, SPACE, exec, rofi -show combi"
      "$mod, SPACE, togglefloating,"

      ",XF86AudioRaiseVolume,exec,pw-volume change +2.5%; pkill -RTMIN+8 waybar"
      ",XF86AudioLowerVolume,exec,pw-volume change -2.5%; pkill -RTMIN+8 waybar"
      ",XF86AudioMute,exec,pw-volume mute toggle; pkill -RTMIN+8 waybar"
    ] ++ (
      # workspaces
      # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
      builtins.concatLists (builtins.genList (x:
        let ws = let c = (x + 1) / 10; in builtins.toString (x + 1 - (c * 10));
        in [
          "ALT, ${ws}, workspace, ${toString (x + 1)}"
          "ALT SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
        ]) 10));

    bindm = [ "ALT, mouse:272, movewindow" "ALT, mouse:273, resizewindow" ];

    input = {
      kb_layout = "us";
      # kb_options = "ctrl:swapcaps";
      mouse_refocus = "false";
      touchpad = {
        natural_scroll = "true";
        disable_while_typing = "true";
        clickfinger_behavior = "true";
        tap-to-click = "true";
        drag_lock = "true";
        tap-and-drag = "true";
      };
    };

    general = {
      gaps_in = 5;
      gaps_out = 20;
      border_size = 2;
      "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
      "col.inactive_border" = "rgba(595959aa)";
      # cursor_inactive_timeout = 3;

      # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
      allow_tearing = "false";
    };

    decoration = {
      rounding = 5;

      blur = {
        enabled = "true";
        size = 6;
        passes = 3;
        new_optimizations = "on";
        ignore_opacity = "on";
        xray = "false";
      };
      drop_shadow = "true";
      shadow_range = 4;
      shadow_render_power = 3;
      "col.shadow" = "rgba(1a1a1aee)";
    };
    dwindle = {
      no_gaps_when_only = 0;
      pseudotile = "true";
      preserve_split = "true";
    };

    master = { new_is_master = "true"; };

    gestures = {
      workspace_swipe = "false";
      workspace_swipe_fingers = 4;
      workspace_swipe_cancel_ratio = 0.15;
    };

    misc = {
      force_default_wallpaper = -1;
      disable_hyprland_logo = "true";
      disable_splash_rendering = "true";
      # hide_cursor_on_key_press = "true";
    };

    debug = { disable_logs = "false"; };
  };

  wayland.windowManager.hyprland.extraConfig = ''
            exec-once = dbus-update-activation-environment --systemd --all
            exec-once = lxsession
            exec-once = hyprpm reload -n

                animations {
                    enabled = yes

                    # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

                    bezier = myBezier, 0.05, 0.9, 0.1, 1.05

                    animation = windows, 1, 7, myBezier
                    animation = windowsOut, 1, 7, default, popin 80%
                    animation = border, 1, 10, default
                    animation = borderangle, 1, 8, default
                    animation = fade, 1, 7, default
                    animation = workspaces, 1, 6, default
                }

                  # window resize
                  bind = $mod Shift, R, submap, resize

                  submap = resize
                  binde = , L, resizeactive, 10 0
                  binde = , H, resizeactive, -10 0
                  binde = , K, resizeactive, 0 -10
                  binde = , J, resizeactive, 0 10
                  bind = , escape, submap, reset
                  submap = reset

                exec-once = waybar & hyprpaper & keepassxc & fcitx5 -r -d

        # ▒█▀▀▀ ▒█░░▒█ ▒█░░▒█
        # ▒█▀▀▀ ▒█▒█▒█ ▒█▒█▒█
        # ▒█▄▄▄ ▒█▄▀▄█ ▒█▄▀▄█

        # exec = eww daemon
        # exec-once = ~/.config/eww/scripts/start.sh

        #  ░▒▓██████▓▒░ ░▒▓██████▓▒░ ░▒▓███████▓▒░
        # ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░
        # ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░
        # ░▒▓████████▓▒░▒▓█▓▒▒▓███▓▒░░▒▓██████▓▒░
        # ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░
        # ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░
        # ░▒▓█▓▒░░▒▓█▓▒░░▒▓██████▓▒░░▒▓███████▓▒░

        exec-once = ags

        exec-once = ydotoold --socket-path="/run/user/$(id -u)/.ydotool_socket" --socket-own="$(id -u):$(id -g)"

                windowrulev2 = opacity 0.9 override 0.5 override 0.9 override, class:(emacs),
                windowrulev2 = float, class:(thunderbird),
                windowrulev2 = float, class:(Zotero), title:(进度)
                windowrulev2 = float, class:(QQ),
                windowrulev2 = opacity 0.9 override 0.5 override 0.9 override, class:(firefox)
                windowrulev2 = opacity 0.9 override 0.5 override 0.9 override, class:(Alacritty)
                windowrulev2 = float, class:(jetbrains-idea), title:(Welcome to IntelliJ IDEA)

    windowrulev2 = float,title:(holo_layer.py)
    windowrulev2 = nofocus,title:(holo_layer.py)
    windowrulev2 = noblur,title:(holo_layer.py)
    windowrulev2 = fakefullscreen,title:(holo_layer.py)

                layerrule = blur, rofi
                layerrule = ignorezero, rofi
                layerrule = noanim, ^(selection)$

        # unscale XWayland
        xwayland {
          force_zero_scaling = true
        }

        # toolkit-specific scale
        env = GDK_SCALE,2
        env = XCURSOR_SIZE,16
  '';

}
