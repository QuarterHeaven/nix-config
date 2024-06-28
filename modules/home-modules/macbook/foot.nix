{ inputs, pkgs, ... }:

{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        term = "xterm-256color";

        font = "BlexMono Nerd Font:size=12";
        dpi-aware = "no";

	include = "${inputs.dotfiles}/foot-themes/tokyonight-night";
      };

      mouse = { hide-when-typing = "yes"; };

      key-bindings = {
	clipboard-copy = "Control+Insert";
      };

      colors = { alpha = 0.7; };
    };

    server.enable = true;
  };
}
