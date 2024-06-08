{ inputs, pkgs, ... }:

{
  # home.file = {
  #   ".config/eww".source = "${inputs.dotfiles}/eww";
  # };
  programs.eww = {
    enable = true;
    configDir = "${inputs.dotfiles}/eww";
    # configDir = null;
  };
}
