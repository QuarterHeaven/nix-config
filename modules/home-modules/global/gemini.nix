{ pkgs, ... }:

{
  home.package = with pkgs; [
    gemini-cli
  ];
}
