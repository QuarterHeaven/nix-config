{ inputs, config, pkgs, ... }:

{
  home.file = {
    ".config/hypr/hyprpaper.conf".source = "${inputs.dotfiles}/hypr/hyprpaper.conf";
    ".config/hypr/scripts".source = "${inputs.dotfiles}/hypr/scripts";
    ".config/hypr/hyprlock.conf".source = "${inputs.dotfiles}/hypr/hyprlock.conf";
  };

  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.package =
    inputs.hyprland.packages.${pkgs.system}.hyprland;
  wayland.windowManager.hyprland.systemd.enable = true;
  wayland.windowManager.hyprland.plugins = [
    inputs.hy3.packages.${pkgs.system}.default
    # inputs.Hyprspace.packages.${pkgs.system}.Hyprspace
    inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
    inputs.hyprgrass.packages.${pkgs.system}.default
  ];

  wayland.windowManager.hyprland.systemd.variables = [ "--all" ];

  wayland.windowManager.hyprland.settings = {
    plugin = {
      hy3 = {
        tabs = {
          height = 2;
          padding = 6;
          render_text = "false";
        };

        autotile = {
          enable = "true";
          trigger_width = 800;
          trigger_height = 500;
        };
      };

       hyprexpo = {
       	columns = 3;
         gap_size = 5;
         # bg_col = rgb(111111);
         workspace_method = "first 1"; # [center/first] [workspace] e.g. first 1 or center m+1

         enable_gesture = false; # laptop touchpad, 4 fingers
         gesture_distance = 300; # how far is the "max"
         gesture_positive = false; # positive = swipe down. Negative = swipe up.
       };

      touch_gestures = {
	sensitivity = 1.0;

	workspace_swipe = true;
	workspace_swipe_fingers = 4;
	workspace_swipe_edge = "d";
	workspace_swipe_cancel_ratio = 0.15;

	long_press_delay = 400;
      };
    };
    "$mod" = "SUPER";
    "$alt" = "ALT";
    monitor = [
      "eDP-1, preferred, 1599x600, 1.600000"
      "desc:AOC Q2701 GWRK8HA002235, preferred, 0x0, 1.600000"
    ];
    bind = [
      "$mod, F, fullscreen, 0"
      "ALT, G, exec, grimblast copy area"
      "ALT, Q, hy3:killactive,"
      "ALT CTRL, T, exec, wezterm"
      "ALT, E, exec, emacs"
      "ALT, SPACE, exec, rofi -show combi"
      "$mod, SPACE, togglefloating,"
      "$mod, G, hy3:changegroup, toggletab"
      "$mod SHIFT, G, hy3:makegroup, tab"
      "$mod, D, hy3:makegroup, h"
      "$mod, S, hy3:makegroup, v"
      "$mod, T, togglesplit,"
      "$mod, H, hy3:movefocus, l"
      "$mod SHIFT, H, hy3:movewindow, l"
      "$mod, J, hy3:movefocus, d"
      "$mod SHIFT, J, hy3:movewindow, d"
      "$mod, K, hy3:movefocus, u"
      "$mod SHIFT, K, hy3:movewindow, u"
      "$mod, L, hy3:movefocus, r"
      "$mod SHIFT, L, hy3:movewindow, r"
      "$mod, S, togglespecialworkspace, magic"
      "$mod SHIFT, S, hy3:movetoworkspace, special:magic"
      #      "ALT, Tab, overview:toggle,"
      # "ALT, Tab, exec, ags -t overview"
      "ALT, Tab, hyprexpo:expo, toggle"
      ",XF86AudioRaiseVolume,exec,pw-volume change +2.5%; pkill -RTMIN+8 waybar"
      ",XF86AudioLowerVolume,exec,pw-volume change -2.5%; pkill -RTMIN+8 waybar"
      ",XF86AudioMute,exec,pw-volume mute toggle; pkill -RTMIN+8 waybar"
      ", edge:r:l, workspace, +1"
      ", swipe:4:u, hyprexpo:expo, toggle"
      ", longpress:3, movewindow"
    ] ++ (
      # workspaces
      # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
      builtins.concatLists (builtins.genList (x:
        let ws = let c = (x + 1) / 10; in builtins.toString (x + 1 - (c * 10));
          in [
            "ALT, ${ws}, workspace, ${toString (x + 1)}"
            "ALT SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
            "$mod ALT, ${ws}, hy3:movetoworkspace, ${toString (x + 1)}, follow"
          ]) 10));
    bindm = [
      "ALT, mouse:272, movewindow"
      "ALT, mouse:273, resizewindow"
    ];
    input = {
      kb_layout = "us";
      kb_options = "ctrl:swapcaps";
      follow_mouse = 1;
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

      # layout = "dwindle";
      layout = "hy3";

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
      pseudotile = "true";
      preserve_split = "true";
    };

    master = { new_is_master = "true"; };

    gestures = {
      workspace_swipe = "true";
      workspace_swipe_fingers = 4;
    };

    misc = {
      force_default_wallpaper = -1;
      disable_hyprland_logo = "true";
      disable_splash_rendering = "true";
    };

    debug = { disable_logs = "false"; };
  };

  wayland.windowManager.hyprland.extraConfig = ''
    exec-once = dbus-update-activation-environment --systemd --all
    exec-once = lxsession

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
          bind = $mod, R, submap, resize

          submap = resize
          binde = , L, resizeactive, 10 0
          binde = , H, resizeactive, -10 0
          binde = , K, resizeactive, 0 -10
          binde = , J, resizeactive, 0 10
          bind = , escape, submap, reset
          submap = reset

        exec-once = waybar & hyprpaper & keepassxc & fcitx5 -r -d & wezterm

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

        windowrule = opacity 0.9 override 0.5 override 0.9 override, ^(emacs)$
        windowrule = float, ^(thunderbird)$
        windowrulev2 = float, class:(Zotero), title:(进度)
        windowrule = float, ^(QQ)$
        windowrulev2 = opacity 0.9 override 0.5 override 0.9 override, class:(firefox)

        layerrule = blur, rofi
        layerrule = ignorezero, rofi
        layerrule = noanim, ^(selection)$

        workspace = 1, monitor:eDP-1, default:true
        workspace = 2, monitor:eDP-1
        workspace = 3, monitor:eDP-1
        workspace = 4, monitor:eDP-1
        workspace = 5, monitor:eDP-1
        workspace = 6, monitor:desc:AOC Q2701 GWRK8HA002235, default:true
        workspace = 7, monitor:desc:AOC Q2701 GWRK8HA002235
        workspace = 8, monitor:desc:AOC Q2701 GWRK8HA002235
        workspace = 9, monitor:desc:AOC Q2701 GWRK8HA002235

# unscale XWayland
xwayland {
  force_zero_scaling = true
}

# toolkit-specific scale
env = GDK_SCALE,2
env = XCURSOR_SIZE,32
  '';
}
