{ inputs, pkgs, ... }:

{
  imports = [
    ./homebrew.nix
    ../langs/clojure.nix
    ../langs/ts.nix
    ../langs/xml.nix
    ../langs/nodejs.nix
    ../langs/vue.nix
    #	../langs/java.nix
  ];
}
