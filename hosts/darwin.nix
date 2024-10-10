{ features, inputs, pkgs, config, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ../modules/nixos-modules/darwin/default.nix
  ];

  environment.systemPackages =
    [
      pkgs.home-manager
    ];

  system.defaults = {
    # minimal dock
    dock = {
      autohide = true;
      show-process-indicators = true;
      show-recents = true;
      static-only = true;
    };
    # a finder that tells me what I want to know and lets me work
    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      FXEnableExtensionChangeWarning = false;
    };

    trackpad = {
      Clicking = true;
      TrackpadThreeFingerDrag = true;
    };

    NSGlobalDomain = {
      NSWindowShouldDragOnGesture = true;
    };
  };

  services.nix-daemon.enable = true;
  nix = {
    package = pkgs.nix;
    settings = {
      "extra-experimental-features" = [ "nix-command" "flakes" ];
      "max-jobs" = 8;
    };
  };

  users.users.takaobsid.packages = with pkgs; [
    nixpkgs-fmt
    tinymist
  ];

  environment.variables = {
    PATH =
      "/opt/local/bin:$PATH:/Users/takaobsid/bin:/Users/takaobsid/.local/share/applications:/Applications/Emacs.app/Contents/MacOS/bin:/Applications/Emacs.app/Contents/MacOS:/Users/takaobsid/mutable_node_modules/bin/";
    LDFLAGS = "-L/usr/local/opt/openssl@3/lib";
    CPPFLAGS = "-I/usr/local/opt/openssl@3/include";
    PKG_CONFIG_PATH = "/usr/local/opt/openssl@3/lib/pkgconfig";
  };

  #  networking.proxy = {
  #    httpProxy = "http://127.0.0.1:1080";
  #    httpsProxy = "http://127.0.0.1:1080";
  #    allProxy = "socks5://127.0.0.1:1081";
  #  };

  home-manager.users.takaobsid = {
    imports = [ ../modules/home-modules/darwin.nix ];
  };

  # Creates /etc/current-system-packages with list of all packages with their versions
  environment.etc."current-system-packages".text = let
    packages = builtins.map (p: "${p.name}") config.environment.systemPackages;
    sortedUnique =
      builtins.sort builtins.lessThan (pkgs.lib.lists.unique packages);
    formatted = builtins.concatStringsSep "\n" sortedUnique;
    in formatted;
}