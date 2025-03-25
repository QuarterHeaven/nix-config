{ inputs, pkgs, ... }:

{
  imports = [
  ];

  environment.systemPackages = with pkgs; [
    fswatch
    binutils
  ];
}
