{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    leiningen
  ];
}
