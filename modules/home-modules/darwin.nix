{ pkgs, ... }:

{
  imports = [ 
	./global/dotfiles.nix 
	./global/yazi.nix
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
