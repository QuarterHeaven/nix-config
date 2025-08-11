{ inputs, config, pkgs, pkgs-unstable, ... }:

{
  imports = [
    ../global
    ./homebrew.nix
    ./proxy.nix
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
