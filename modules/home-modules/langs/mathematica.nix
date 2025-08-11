{ pkgs, inputs, ... }:

{
  users.users.takaobsid.packages = with pkgs; [ mathematica ];
}
