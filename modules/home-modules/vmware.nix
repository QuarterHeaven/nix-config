{ config, lib, pkgs, features, home-manager, dotfiles, ... }:

{
  imports = [ ./global ./home.nix ];
}
