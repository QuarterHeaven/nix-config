{ pkgs, config, dotfiles, ... }:

{
  home.file = {
    ".config/starship.toml".source = ../../dotfiles/starship.toml;
    # ".sops.yaml".source = ../../dotfiles/.sops.yaml;
    ".config/wezterm/wezterm.lua".source = ../../dotfiles/wezterm.lua;
  };
}
