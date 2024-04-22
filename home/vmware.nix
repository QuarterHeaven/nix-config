{ config, inputs, pkgs, ...}:

{
  home-manager.users.takaobsid = { imports = [ ./vmware-home.nix ]; };
}
