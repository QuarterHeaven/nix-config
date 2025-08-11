{ inputs, pkgs, ... }:

{
  imports = [
    ../ags.nix
    ../aria2.nix
    ../desktop/gnome.nix
    ../desktop/hyprland.nix
    ../desktop/niri.nix
    ../dropbox.nix
    ../fcitx5.nix
    ./flatpak.nix
    ./gestures.nix
    ./kdeconnect.nix
    ../k8s.nix
    ./mpv.nix
    ../onedrive.nix
    ../pptp.nix
    # ../sops.nix
    ./singbox.nix
    ./vmware.nix
    ./xremap.nix
  ];

  users.users.takaobsid.packages = [
    (pkgs.callPackage ./cider {})
  ];
}
