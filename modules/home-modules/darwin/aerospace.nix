{ inputs, pkgs, ...}:

{
  home.file = {
    ".aerospace.toml".source = "${inputs.dotfiles}/aerospace.toml";
  };
}
