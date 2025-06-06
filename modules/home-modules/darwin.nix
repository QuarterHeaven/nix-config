{ pkgs, ... }:

{
  imports = [ 
    ./global
    ./darwin 
    ./home-darwin.nix 
  ];

  home.packages = with pkgs; [
    # unstable.zotero_7
    keepassxc
    libtool
    libsecret

    imagemagick
    libwebp
    telegram-desktop

    pngpaste
    unstable.aider-chat
    # grip-search
  ];

  services.mako = {
    enable = false;
    settings.default-timeout = 4000;
  };

  programs.thunderbird = {
    enable = false;
    profiles."Taka Obsid" = { isDefault = true; };
  };
 
  programs.mpv = {
    enable = false;
  };
}
