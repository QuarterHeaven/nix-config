{ inputs, pkgs, config, dotfiles, ... }:

{
  home.file = {
    ".config/starship.toml".source = "${inputs.dotfiles}/starship.toml";
    # ".sops.yaml".source = ../../dotfiles/.sops.yaml;
    ".config/wezterm/wezterm.lua".source = "${inputs.dotfiles}/wezterm.lua";
  };
}
