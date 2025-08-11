{ pkgs, ... }:

let
  emacsPkg = pkgs.emacs-master-pgtk-with-igc;
in
  {
    home.packages = [
      emacsPkg
      pkgs.emacs-lsp-booster
    ];
  }
