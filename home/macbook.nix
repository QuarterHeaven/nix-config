{ config, inputs, pkgs, ... }:

{
  home-manager.users.takaobsid = { imports = [ ./macbook-home.nix ]; };
}
