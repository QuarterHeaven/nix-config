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
    ./unison.nix
  ];
}
