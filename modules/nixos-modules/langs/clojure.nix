{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    leiningen
    clojure
    clojure-lsp
  ];
}
