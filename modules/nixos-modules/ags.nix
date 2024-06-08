{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ webkitgtk_4_1 dart-sass gtk3 ];
}
