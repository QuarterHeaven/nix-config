{ pkgs, ...}:

{
  home.packages = with pkgs; [
    sbc
  ];
}
