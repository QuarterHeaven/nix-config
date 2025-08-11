{ config, pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    nodePackages.nrm
    nodePackages.yarn
    nodePackages.pnpm
    nodePackages.nodejs
  ];
}
