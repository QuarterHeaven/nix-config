{ pkgs, ... }:

{
  environment.defaultPackages = with pkgs; [
    graphviz
  ];
}
