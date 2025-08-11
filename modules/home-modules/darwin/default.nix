{ ... }:

{
  imports = [
    ./emacs
    # ./java-darwin.nix
    ./dotfiles.nix
    ./sync_orgs.nix
    ./ts-darwin.nix
    ./hammerspoon.nix
    # ./aerospace.nix
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
    ./unison.nix
  ];
}
