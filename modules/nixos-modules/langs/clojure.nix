{ pkgs, ... }:

{
  environment.defaultPackages = with pkgs; [
    leiningen
  ];
}
