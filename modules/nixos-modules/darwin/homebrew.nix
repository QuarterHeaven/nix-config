{ ... }:

{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      # cleanup = "zap";
      cleanup = "none";
      extraFlags = [ "--force" ];
    };

    taps = [
      # "QuarterHeaven/selfuse"
      # "QuarterHeaven/selfuse-cask"
      "nikitabobko/tap"
      "koekeishiya/formulae"
      "FelixKratz/formulae"
      "mrkai77/cask"
      "laishulu/homebrew"
      "BarutSRB/tap"
    ];

    brews = [
      "autoconf"
      "borders"
      "gnutls"
      "tree-sitter"
      "pkg-config"
      {
        name = "tdlib";
        args = [ "HEAD" ];
      }
      "mit-scheme"
      "guile"
      # "eless"
      "fontconfig"
      "pidof"
      "jenv" # java environment
      "macism"
      "ncdu"
      "libmps"
      "sbcl"
    ];

    casks = [
      "wezterm"
      "intellij-idea"
      "intellij-idea-ce"
      "mos" # mouse controller
      "lulu" # defend upgrade
      "localsend"
#      "qq"
#      "wechat"
      "visual-studio-code"
      "squirrel-app"
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
      # "jordanbaird-ice@beta" use thaw instead
      "thaw"
      "windterm"
      "font-symbols-only-nerd-font"
      "font-material-symbols"
      # "kitty" # build fron source
      # "zen-browser"
      "keycastr"
      "ghostty"
      "barutsrb/tap/omniwm"
    ];
  };
}
