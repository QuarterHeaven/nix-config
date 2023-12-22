{ config, lib, pkgs, features, home-manager, dotfiles, ... }:

{
  imports = [
    ../features/global
    ../home.nix
  ];
}
