{ pkgs, ... }:

{
  imports = [ ./global ./macbook ./home.nix ];

  home.packages = with pkgs; [
    qq
    weechat
    # feishu
    wezterm
    unstable.zotero_7
    keepassxc
    libtool
    libsecret
    microsoft-edge

    imagemagick
    libwebp
    telegram-desktop

    spacedrive
    kitty

    appeditor
  ];

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 16;
  };

  services.mako = {
    enable = false;
    defaultTimeout = 4000;
  };

  programs.thunderbird = {
    enable = true;
    profiles."Taka Obsid" = { isDefault = true; };
  };
}
