{ ... }:

{
  homebrew = {
    enable = true;

    brews = [
      "autoconf"
      "borders"
      "gnutls"
      "tree-sitter"
      "pkg-config"
      # "tdlib"
      "mit-scheme"
      # "eless"
      "fontconfig"
      "pidof"
      "jenv" # java environment
      "macism"
      "ncdu"
      "libmps"
      "sbcl"
      "koekeishiya/formulae/yabai"
    ];

    casks = [
      "wezterm"
      "intellij-idea"
      "intellij-idea-ce"
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
      "jordanbaird-ice"
      "windterm"
      "font-symbols-only-nerd-font"
      "font-material-symbols"
      # "kitty" # build fron source
      # "zen-browser"
      "keycastr"
      "ghostty"
    ];

    taps = [
      # "QuarterHeaven/selfuse"
      # "QuarterHeaven/selfuse-cask"
      "nikitabobko/tap"
      "koekeishiya/formulae"
      "FelixKratz/formulae"
      "mrkai77/cask"
      "laishulu/homebrew"
    ];
  };
}
