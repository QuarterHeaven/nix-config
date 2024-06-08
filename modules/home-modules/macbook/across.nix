{ inputs, pkgs, ... }:

{
  home.packages = [
    inputs.across.packages.${pkgs.system}.across
  ];
}
