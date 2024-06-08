{ pkgs, ... }:

{
  users.users.takaobsid.packages = with pkgs; [
    mpv
  ];
}
