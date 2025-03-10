{ pkgs, ... }:

{
  home.packages = with pkgs; [
    emacs-lsp-booster
  ];
}
