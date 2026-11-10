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
    jq
    gnutls
    tree-sitter
    coreutils-prefixed
    mps
    comma
  ];
}
