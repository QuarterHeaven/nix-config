{ config, lib, pkgs, features, home-manager, dotfiles, ... }:

{
  imports = [ ../modules/global ./home.nix ];
}
