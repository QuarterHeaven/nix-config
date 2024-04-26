{ config, lib, pkgs, features, home-manager, dotfiles, ... }:

{
  imports = [ ./global ./macbook ./home.nix ];

  home.packages = with pkgs; [
    qq
    wezterm
    unstable.zotero_7
    keepassxc
    libtool
    libsecret
    microsoft-edge
    imagemagick
    telegram-desktop
    spacedrive
    kitty
  ];

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 22;
  };

  services.mako = {
    enable = true;
    defaultTimeout = 4000;
  };

  programs.thunderbird = {
    enable = true;
    profiles."Taka Obsid" = { isDefault = true; };
  };
}
