{ config, pkgs, ... }:

{
  home.sessionVariables = {
    # PATH = "/opt/homebrew/bin:$PATH:$HOME/bin:$HOME/.local/share/applications:/Applications/Emacs.app/Contents/MacOS/bin:/Applications/Emacs.app/Contents/MacOS:$HOME/.npm-packages/bin/";
    MAVEN_PATH = "${pkgs.maven}/maven";
    # JAVA_HOME = "${pkgs.jdk8}/zulu-8.jdk/Contents/Home";
    LDFLAGS = "-L/usr/local/opt/openssl@3/lib";
    CPPFLAGS = "-I/usr/local/opt/openssl@3/include";
    PKG_CONFIG_PATH = "/usr/local/opt/openssl@3/lib/pkgconfig";
  };

  home.sessionPath = [
    "/opt/homebrew/bin"
    "$HOME/bin"
    "$HOME/.local/share/applications"
    "/Applications/Emacs.app/Contents/MacOS/bin"
    "/Applications/Emacs.app/Contents/MacOS"
    "$HOME/.npm-packages/bin/"
    "/run/current-system/sw/bin"
    "/etc/profiles/per-user/takaobsid/bin"
  ];
  
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
