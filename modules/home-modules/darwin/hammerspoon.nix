{ inputs, pkgs, ... }:

{
  home.file = {
        ".hammerspoon" = {
      source = "${inputs.dotfiles}/hammerspoon";
      recursive = true;
    };
  };
}
