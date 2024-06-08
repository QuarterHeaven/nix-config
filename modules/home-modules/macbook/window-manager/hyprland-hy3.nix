{ inputs, config, pkgs, ... }:

{
  wayland.windowManager.hyprland.plugins =
    [ inputs.hy3.packages.${pkgs.system}.default ];

  general = { layout = "hy3"; };

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
    };

    input = { follow_mouse = 1; };
  };

  bind = [
    "ALT, Q, hy3:killactive,"
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
    "Alt SHIFT, S, hy3:movetoworkspace, special:magic"
  ] ++ (
    # workspaces
    # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
    builtins.concatLists (builtins.genList (x:
      let ws = let c = (x + 1) / 10; in builtins.toString (x + 1 - (c * 10));
      in [
        "$mod ALT, ${ws}, hy3:movetoworkspace, ${toString (x + 1)}, follow"
      ]) 10));

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
