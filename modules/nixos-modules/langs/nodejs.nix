{ config, pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    nodePackages.nrm
    nodePackages.yarn
    nodePackages.pnpm
    nodePackages.nodejs
  ];
}
