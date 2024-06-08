{ ... }:

{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        term = "xterm-256color";

        font = "BlexMono Nerd Font:size=16";
        dpi-aware = "yes";
      };

      mouse = { hide-when-typing = "yes"; };

      # colors = { alpha = 0.7; };
    };
  };
}
