{ features, inputs, pkgs, config, ... }:

{
  networking.networkmanager = {
    enable = true;
    unmanaged = [ "type:ethernet" ];
  };

  imports = [ # Include the results of the hardware scan.
    ../hard-files/hardware/hardware-configuration-macbook.nix
    ../modules/nixos-modules/macbook/default.nix
  ];

  hardware = {
    firmware = [
      (pkgs.stdenvNoCC.mkDerivation {
        name = "brcm-firmware";

        buildCommand = ''
                    dir="$out/lib/firmware"
                    mkdir -p "$dir"
          echo "$dir"
                    cp -r ${../hard-files/firmware}/* "$dir"
        '';
      })
    ];

    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    graphics.enable = true;

    graphics.extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  # Bootloader.
  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
    };
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
  };

  boot.kernelParams = [
    "hid_apple.swap_opt_cmd=1"
    "quiet"
    "transparent_hugepage=never"
  ];
  boot.plymouth.enable = true;
  boot.plymouth.theme = "breeze";
  boot.initrd.verbose = false;
  boot.consoleLogLevel = 0;
  security.polkit.enable = true;
  # reboot/poweroff for unprivileged users
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (
        subject.isInGroup("users")
        && (
          action.id == "org.freedesktop.login1.reboot" ||
          action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
          action.id == "org.freedesktop.login1.power-off" ||
          action.id == "org.freedesktop.login1.power-off-multiple-sessions"
        )
      )
      {
        return polkit.Result.YES;
      }
    })
  '';

  services.dbus.enable = true;

  services.xserver = { enable = true; };

  # reenable keyboard and touch-bar after sleep
  systemd.services."re-enable-keyboard-and-touchbar-after-sleep" = {
    description = "re-enable keyboard and touchbar after sleep";
    wantedBy = [ "suspend.target" ];
    after = [ "systemd-suspend.service" ];
    script = "";
    serviceConfig.Type = "simple";
  };

  environment.systemPackages = with pkgs; [
    solaar
    keyd
    libinput
    mesa
    blueman
    # lxqt-policykit-agent
    lxde.lxsession
    wl-gammactl
    wl-clipboard
    wayshot
    brightnessctl
    clash-verge-rev
    handlr
    xsel
    # inputs.clipboard-sync.packages.${system}.default
  ];

  services.clipboard-sync.enable = true;

  services.xserver.xkb.layout = "us";
  services.libinput = {
    enable = true;
    touchpad = { disableWhileTyping = true; };
  };

  users.users.takaobsid.packages = with pkgs; [
    wlr-randr
    nixfmt-classic
    nixpkgs-fmt
    tinymist
    gnome.sushi
    doublecmd

    easyeffects
    grim
    slurp
    grimblast
    tmpwatch
    libqalculate
    pamixer
    just
    nwg-panel

    libreoffice
    # wpsoffice                # use flatpak version instead

    onlyoffice-bin_latest

    appimage-run

    config.nur.repos.xddxdd.baidunetdisk
  ];

  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = "\\xff\\xff\\xff\\xff\\x00\\x00\\x00\\x00\\xff\\xff\\xff";
    magicOrExtension = "\\x7fELF....AI\\x02";
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [ "zh_CN.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" ];
  };

  services.v2raya.enable = true;

  services.upower.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    INPUT_METHOD = "fcitx5";
    #    GTK_IM_MODULE = "wayland";
    WEBKIT_DISABLE_COMPOSITING_MODE = "1";
    RUST_BACKTRACE = "1";
    XMODIFIERS = "@im=fcitx";
    GTK_IM_MODULE="fcitx";
    QT_IM_MODULE="fcitx";
    SDL_IM_MODULE="fcitx";
    GLFW_IM_MODULE="fcitx";
    PATH =
      "$PATH:/home/takaobsid/bin:/home/takaobsid/.local/share/applications";
    YDOTOOL_SOCKET="/run/user/$(id -u)/.ydotool_socket";
  };

  services.xserver.desktopManager.runXdgAutostartIfNone = true;
  xdg.mime.enable = true;

  networking.proxy = {
    httpProxy = "http://127.0.0.1:1080";
    httpsProxy = "http://127.0.0.1:1080";
    allProxy = "socks5://127.0.0.1:1081";
  };

  home-manager.users.takaobsid = {
    imports = [ ../modules/home-modules/macbook.nix ];
  };

  # Creates /etc/current-system-packages with list of all packages with their versions
  environment.etc."current-system-packages".text = let
    packages = builtins.map (p: "${p.name}") config.environment.systemPackages;
    sortedUnique =
      builtins.sort builtins.lessThan (pkgs.lib.lists.unique packages);
    formatted = builtins.concatStringsSep "\n" sortedUnique;
  in formatted;
}
