{ config, lib, pkgs, features, home-manager, dotfiles, ... }:

{
  imports = [
    ../features/global
    ../features/macbook
    ../home.nix
  ];
}
