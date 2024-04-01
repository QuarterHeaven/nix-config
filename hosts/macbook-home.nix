{ config, lib, pkgs, features, home-manager, dotfiles, ... }:

{
  imports = [
    ../features/global
    ../features/macbook
    ../home.nix
  ];

  home.packages = with pkgs; [
    qq
    wezterm
    unstable.zotero_7
    keepassxc
    microsoft-edge
    imagemagick
    telegram-desktop
    spacedrive
    kitty
  ];
}
