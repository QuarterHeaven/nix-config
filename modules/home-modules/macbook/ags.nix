{ inputs, pkgs, ... }:

{
  imports = [ inputs.ags.homeManagerModules.default ];

  home.packages = [ pkgs.bun pkgs.swww ];

  programs.ags = {
    enable = true;
    configDir = "${inputs.dotfiles}/ags";
    extraPackages = with pkgs; [ gtksourceview webkitgtk accountsservice ];
  };

  # home.file.".config/ags" = {
  #   source = "${inputs.dotfiles}/ags";
  #   executable = true;
  #   recursive = true;
  # };
}
