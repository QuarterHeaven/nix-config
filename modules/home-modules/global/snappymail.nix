{ pkgs, ... }:

{
  home.packages = with pkgs; [
    snappymail
  ];
}
