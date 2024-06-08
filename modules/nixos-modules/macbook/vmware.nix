{ pkgs, ... }:

{
  virtualisation.virtualbox = { host.enable = false; };
  users.extraGroups.vboxusers.members = [ "takaobsid" ];
}
