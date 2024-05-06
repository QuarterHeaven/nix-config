{ inputs, ... }:

{
  home.file = { ".config/waybar".source = "${inputs.dotfiles}/waybar"; };
  programs.waybar = { enable = true; };
}
