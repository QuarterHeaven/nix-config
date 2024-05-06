{ inputs, pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
#	package = pkgs.rofi;
    plugins = [ pkgs.rofi-calc ];
  };

  home.file = { ".config/rofi".source = "${inputs.dotfiles}/rofi"; };
}
