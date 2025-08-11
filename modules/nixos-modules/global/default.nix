{ inputs, pkgs, ... }:

{
  imports = [
  ];

  environment.systemPackages = with pkgs; [
    fswatch
    binutils
    unison
    # gemini-cli
    just
    gnutls
    tree-sitter
    coreutils-prefixed
    mps
    comma
  ];
}
