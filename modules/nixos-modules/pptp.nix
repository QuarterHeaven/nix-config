{ inputs, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ pptp ppp ];
}
