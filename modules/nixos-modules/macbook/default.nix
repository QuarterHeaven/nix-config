{ inputs, pkgs, ... }:

{
  imports = [
    ../ags.nix
    ../desktop/gnome.nix
    ../desktop/hyprland.nix
    ../desktop/niri.nix
    ../dropbox.nix
    ./fcitx5.nix
    ./gestures.nix
    ./kdeconnect.nix
    ../k8s.nix
    ../langs
    ./mpv.nix
    ../pptp.nix
    ./vmware.nix
    ./xremap.nix
  ];

  users.users.takaobsid.packages = [
    (pkgs.callPackage ./cider {})
  ];
}
