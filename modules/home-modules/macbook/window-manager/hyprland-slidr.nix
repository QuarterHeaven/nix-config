{ inputs, config, pkgs, ... }:

{
  wayland.windowManager.hyprland.plugins = [
    inputs.hyprslidr.packages.${pkgs.system}.hyprslidr
  ];

  wayland.windowManager.hyprland.settings = {
    general = { layout = "slidr"; };

    input = {
      follow_mouse = 0;
    };

    bind = [
      "ALT, Q, killactive,"

      "$mod, H, slidr:movefocus, l"
      "$mod SHIFT, H, movewindow, l"
      "$mod, J, slidr:movefocus, d"
      "$mod SHIFT, J, movewindow, d"
      "$mod, K, slidr:movefocus, u"
      "$mod SHIFT, K, movewindow, u"
      "$mod, L, slidr:movefocus, r"
      "$mod SHIFT, L, movewindow, r"
      "Alt SHIFT, S, movetoworkspace, special:magic"

      "$mod, R, slidr:cyclesize,"

      # Admit/Expel
      "$mod, I, slidr:admitwindow,"
      "$mod, O, slidr:expelwindow,"

      "Alt, S, togglespecialworkspace, magic"
      "Alt SHIFT, S, movetoworkspace, special:magic"
    ];

  };
  wayland.windowManager.hyprland.extraConfig = ''
    # Center submap
    # will switch to a submap called center
    bind = $mod, C, submap, center
    # will start a submap called "center"
    submap = center
    # sets repeatable binds for resizing the active window
    bind = , C, slidr:alignwindow, c
    bind = , C, submap, reset
    bind = , right, slidr:alignwindow, r
    bind = , right, submap, reset
    bind = , left, slidr:alignwindow, l
    bind = , left, submap, reset
    bind = , up, slidr:alignwindow, u
    bind = , up, submap, reset
    bind = , down, slidr:alignwindow, d
    bind = , down, submap, reset
    # use reset to go back to the global submap
    bind = , escape, submap, reset
    # will reset the submap, meaning end the current one and return to the global one
    submap = reset

    workspace = 1, monitor:eDP-1, default:true
    workspace = 2, monitor:desc:AOC Q2701 GWRK8HA002235, default:true
  '';
}
