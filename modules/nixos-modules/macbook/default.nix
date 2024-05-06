{ inputs, pkgs, ...}:

{
  imports = [
    ./fcitx5.nix
    ../desktop/gnome.nix
    ../desktop/hyprland.nix
    ../desktop/niri.nix
    ../dropbox.nix
    ../pptp.nix
    ../ags.nix
  ];
}
