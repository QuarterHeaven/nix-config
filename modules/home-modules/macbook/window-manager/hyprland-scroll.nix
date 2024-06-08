{ inputs, config, pkgs, ... }:

{
  wayland.windowManager.hyprland.settings = {
    general = { layout = "scroller"; };

    input = {
      follow_mouse = 0;
      float_switch_override_focus = 0;
    };

    bind = [
      "ALT, Q, killactive,"
      # "$mod, G, scroller:admitwindow,"
      # "$mod SHIFT, G, scroller:expelwindow, "

      "$mod, H, scroller:movefocus, l"
      "$mod SHIFT, H, scroller:movewindow, l"
      "$mod, J, scroller:movefocus, d"
      "$mod SHIFT, J, scroller:movewindow, d"
      "$mod, K, scroller:movefocus, u"
      "$mod SHIFT, K, scroller:movewindow, u"
      "$mod, L, scroller:movefocus, r"
      "$mod SHIFT, L, scroller:movewindow, r"
      "$mod, home, scroller:movefocus, begin"
      "$mod SHIFT, home, scroller:movewindow, begin"
      "$mod, end, scroller:movefocus, end"
      "$mod SHIFT, end, scroller:movewindow, end"
      "$mod, page_up, scroller:movefocus, begin"
      "$mod SHIFT, page_up, scroller:movewindow, begin"
      "$mod, page_down, scroller:movefocus, end"
      "$mod SHIFT, page_down, scroller:movewindow, end"
      "Alt SHIFT, S, movetoworkspace, special:magic"

      "$mod, equal, scroller:cyclesize, +1"
      "$mod, minus, scroller:cyclesize, -1"

      "$mod, R, scroller:fitsize, active"

      # Admit/Expel
      "$mod, I, scroller:admitwindow,"
      "$mod, O, scroller:expelwindow,"

      "Alt, S, togglespecialworkspace, magic"
      "Alt SHIFT, S, movetoworkspace, special:magic"

      # Grass
      # ", swipe:4:l, scroller:movefocus, r"
      # ", swipe:4:r, scroller:movefocus, l"
      # ", swipe:4:u, hycov:toggleoverview,"
      # ", swipe:4:d, scroller:toggleoverview,"
    ];

  };
  wayland.windowManager.hyprland.extraConfig = ''
    # Center submap
    # will switch to a submap called center
    bind = $mod, C, submap, center
    # will start a submap called "center"
    submap = center
    # sets repeatable binds for resizing the active window
    bind = , C, scroller:alignwindow, c
    bind = , C, submap, reset
    bind = , right, scroller:alignwindow, r
    bind = , right, submap, reset
    bind = , left, scroller:alignwindow, l
    bind = , left, submap, reset
    bind = , up, scroller:alignwindow, u
    bind = , up, submap, reset
    bind = , down, scroller:alignwindow, d
    bind = , down, submap, reset
    # use reset to go back to the global submap
    bind = , escape, submap, reset
    # will reset the submap, meaning end the current one and return to the global one
    submap = reset

    # Resize submap
    # will switch to a submap called resize
    bind = $mod SHIFT, R, submap, resize
    # will start a submap called "resize"
    submap = resize
    # sets repeatable binds for resizing the active window
    binde = , L, resizeactive, 100 0
    binde = , H, resizeactive, -100 0
    binde = , K, resizeactive, 0 -100
    binde = , J, resizeactive, 0 100
    # use reset to go back to the global submap
    bind = , escape, submap, reset
    # will reset the submap, meaning end the current one and return to the global one
    submap = reset

    # Fit size submap
    # will switch to a submap called fitsize
    bind = $mod, W, submap, fitsize
    # will start a submap called "fitsize"
    submap = fitsize
    # sets binds for fitting columns/windows in the screen
    bind = , W, scroller:fitsize, visible
    bind = , W, submap, reset
    bind = , L, scroller:fitsize, toend
    bind = , L, submap, reset
    bind = , H, scroller:fitsize, tobeg
    bind = , H, submap, reset
    bind = , K, scroller:fitsize, active
    bind = , K, submap, reset
    bind = , J, scroller:fitsize, all
    bind = , J, submap, reset
    # use reset to go back to the global submap
    bind = , escape, submap, reset
    # will reset the submap, meaning end the current one and return to the global one
    submap = reset

    # overview keys
    # bind key to toggle overview (normal)
    bind = ALT, Tab, scroller:toggleoverview
    # overview submap
    # will switch to a submap called overview
    bind = ALT, Tab, submap, overview
    # will start a submap called "overview"
    submap = overview
    bind = , L, scroller:movefocus, right
    bind = , H, scroller:movefocus, left
    bind = , K, scroller:movefocus, up
    bind = , J, scroller:movefocus, down
    # use reset to go back to the global submap
    bind = , escape, scroller:toggleoverview,
    bind = , escape, submap, reset
    bind = , return, scroller:toggleoverview,
    bind = , return, submap, reset
    bind = ALT, Tab, scroller:toggleoverview,
    bind = ALT, Tab, submap, reset
    # will reset the submap, meaning end the current one and return to the global one
    submap = reset

    # Marks
    bind = ALT, M, submap, marksadd
    submap = marksadd
    bind = , a, scroller:marksadd, a
    bind = , a, submap, reset
    bind = , b, scroller:marksadd, b
    bind = , b, submap, reset
    bind = , c, scroller:marksadd, c
    bind = , c, submap, reset
    bind = , escape, submap, reset
    submap = reset

    bind = ALT SHIFT, M, submap, marksdelete
    submap = marksdelete
    bind = , a, scroller:marksdelete, a
    bind = , a, submap, reset
    bind = , b, scroller:marksdelete, b
    bind = , b, submap, reset
    bind = , c, scroller:marksdelete, c
    bind = , c, submap, reset
    bind = , escape, submap, reset
    submap = reset

    bind = ALT, apostrophe, submap, marksvisit
    submap = marksvisit
    bind = , a, scroller:marksvisit, a
    bind = , a, submap, reset
    bind = , b, scroller:marksvisit, b
    bind = , b, submap, reset
    bind = , c, scroller:marksvisit, c
    bind = , c, submap, reset
    bind = , escape, submap, reset
    submap = reset

    bind = ALT CTRL, M, scroller:marksreset

    workspace = 1, monitor:eDP-1, default:true
    workspace = 2, monitor:desc:AOC Q2701 GWRK8HA002235, default:true
  '';
}
