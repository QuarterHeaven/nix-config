{ config, pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    nodePackages.nrm
    nodePackages.yarn
    nodePackages.pnpm
    nodejs-18_x
  ];
}
