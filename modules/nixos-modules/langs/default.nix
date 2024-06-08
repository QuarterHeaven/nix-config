{ inputs, pkgs, ... }:

{
  imports = [ ./java.nix ./nodejs.nix ./mysql.nix ./ts.nix ./xml.nix ./wolfram.nix ./clojure.nix ];
}
