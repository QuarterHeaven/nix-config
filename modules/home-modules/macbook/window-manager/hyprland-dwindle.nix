{ inputs, pkgs, config, ... }:

{
  wayland.windowManager.hyprland.settings = {
    general = { layout = "dwindle"; };

    bind = [
      "$mod, H, movefocus, l"
      "$mod SHIFT, H, movewindow, l"
      "$mod, J, movefocus, d"
      "$mod SHIFT, J, movewindow, d"
      "$mod, K, movefocus, u"
      "$mod SHIFT, K, movewindow, u"
      "$mod, L, movefocus, r"
      "$mod SHIFT, L, movewindow, r"

      "Alt, S, togglespecialworkspace, magic"

      "Alt SHIFT, S, movetoworkspace, special:magic"
    ];

    input = { follow_mouse = 1; };
  };

  wayland.windowManager.hyprland.extraConfig = ''
    workspace = 1, monitor:eDP-1, default:true
    workspace = 2, monitor:eDP-1
    workspace = 3, monitor:eDP-1
    workspace = 4, monitor:eDP-1
    workspace = 5, monitor:eDP-1
    workspace = 6, monitor:desc:AOC Q2701 GWRK8HA002235, default:true
    workspace = 7, monitor:desc:AOC Q2701 GWRK8HA002235
    workspace = 8, monitor:desc:AOC Q2701 GWRK8HA002235
    workspace = 9, monitor:desc:AOC Q2701 GWRK8HA002235
    workspace = 10, monitor:desc:AOC Q2701 GWRK8HA002235
  '';
}
