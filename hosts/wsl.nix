{ config, lib, pkgs, features, home-manager, dotfiles, ... }:

{
  imports = [
    # <nixos-wsl/modules>
    ../features
    ../home.nix
  ];
}
