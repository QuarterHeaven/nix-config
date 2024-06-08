{ pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    vial
    via
  ];
}
