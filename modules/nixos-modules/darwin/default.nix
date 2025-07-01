{ inputs, config, pkgs, pkgs-unstable, ... }:

{
  imports = [
    ../global
    ./homebrew.nix
    ./proxy.nix
    ../langs/clojure.nix
    ../langs/dotnet.nix
    ../langs/ts.nix
    ../langs/xml.nix
    ../langs/nodejs.nix
    # ../langs/lua.nix
    ../langs/vue.nix
    ../langs/go.nix
    # ../langs/common-lisp.nix
    ../langs/cpp.nix
    ../langs/dot.nix
    # ./sketchybar
    # ./unison.nix
  ];
  
  # services.sketchybar = import ./sketchybar config pkgs pkgs-unstable;

  environment.systemPackages = with pkgs; [
    # kitty # use brew
    iina # media player
    neovim
    # aerospace
  ];
}
