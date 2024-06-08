{ inputs, pkgs, ... }:

{
  home.file = { ".config/waybar".source = "${inputs.dotfiles}/waybar"; };
  home.packages = with pkgs; [ libappindicator ];
  programs.waybar = {
    enable = true;
    package = inputs.waybar.packages.${pkgs.system}.waybar;
  };
}
