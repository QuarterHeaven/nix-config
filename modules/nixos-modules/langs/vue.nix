{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vue-language-server
  ];
}
