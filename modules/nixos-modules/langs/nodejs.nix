{ config, pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    nodePackages.nrm
    nodePackages.yarn
    nodejs_18
  ];
}
