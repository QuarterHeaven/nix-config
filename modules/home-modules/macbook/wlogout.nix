{ inputs, ... }:

{
  home.file = { ".config/wlogout".source = "${inputs.dotfiles}/wlogout"; };
}
