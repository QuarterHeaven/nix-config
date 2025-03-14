{ inputs, pkgs, ... }:

{
  imports = [
    ../global
    ./homebrew.nix
    ../langs/clojure.nix
    ../langs/ts.nix
    ../langs/xml.nix
    ../langs/nodejs.nix
    ../langs/vue.nix
    # ../langs/java-darwin.nix
    ../langs/go.nix
    # ../langs/common-lisp.nix
  ];

  environment.systemPackages = with pkgs; [
    # kitty # use brew
    iina # media player
    neovim
  ];
}
