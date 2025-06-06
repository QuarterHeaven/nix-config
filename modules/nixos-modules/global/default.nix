{ inputs, pkgs, ... }:

{
  imports = [
  ];

  environment.systemPackages = with pkgs; [
    fswatch
    binutils
    unison
    gnutls
    tree-sitter
  ];
}
