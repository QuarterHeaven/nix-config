{ config, inputs, pkgs, ...}:

{
  home-manager.users.takaobsid = { imports = [ ./wsl-home.nix ]; };
}
