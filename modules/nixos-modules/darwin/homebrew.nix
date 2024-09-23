{ ... }:

{
  homebrew = {
    enable = true;

    brews = [
      # "imagemagick"
      # "displayplacer"
      # "QuarterHeaven/selfuse/maven"
      # "sops"
      # "autoconf"
      # "automake" 
      # "texinfo" 
      # "QuarterHeaven/selfuse/gnutls"
      # "QuarterHeaven/selfuse/openssl@3"
      # "pkg-config"
      # "tdlib"
      "sketchybar"
      "mit-scheme"
    ];

    casks = [
      "wezterm"
      # "onedrive"
      "firefox"
      "intellij-idea"
      "mos" # mouse controller
      "lulu" # defend upgrade
      "qq"
      "wechat"
      "visual-studio-code"
      "squirrel"
      #"nikitabobko/tap/aerospace"
      "apifox"
      "beekeeper-studio"
      "usr-sse2-rdm"
      "raycast"
      "switchkey"
      "betterdisplay"
      "sf-symbols"
      "thunderbird"
      "orbstack"
      "mrkai77/cask/loop"
      "google-chrome"
      "microsoft-edge"
      "xquartz"
    ];

    taps = [
      # "QuarterHeaven/selfuse"
      # "QuarterHeaven/selfuse-cask"
      "nikitabobko/tap"
      "koekeishiya/formulae"
      "FelixKratz/formulae"
      "mrkai77/cask"
    ];
  };
}
