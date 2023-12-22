{ config, lib, pkgs, features, home-manager, dotfiles, ... }:

{
  imports = [
    # <nixos-wsl/modules>
    ../features/global
    ../features/wsl
    ../home.nix
  ];
}
