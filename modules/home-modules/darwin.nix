{ pkgs, ... }:

{
  imports = [ 
    # 	./global/dotfiles.nix 
    # ./global/yazi.nix
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
    mpv

    pngpaste
    unstable.aider-chat
    # grip-search
  ];

  services.mako = {
    enable = false;
    defaultTimeout = 4000;
  };

  programs.thunderbird = {
    enable = false;
    profiles."Taka Obsid" = { isDefault = true; };
  };
}
