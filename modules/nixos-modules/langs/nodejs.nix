{ config, pkgs, inputs, ... }:

{
  environment.defaultPackages = with pkgs; [
    nodePackages.nrm
    nodePackages.yarn
    nodejs_18
  ];
}
