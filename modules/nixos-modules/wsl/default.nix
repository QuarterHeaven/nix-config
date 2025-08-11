{ pkgs, ... }:

{
  imports = [
    ../global
    ../langs
    ../fcitx5.nix
    ./mongodb.nix
  ];
}
