{ features, inputs, pkgs, config, ... }:

{
  networking.networkmanager = {
    enable = true;
    unmanaged = [ "type:ethernet" ];
  };

  imports = [ # Include the results of the hardware scan.
    # "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; narHash = "sha256-+BatEWd4HlMeK7Ora+gYIkarjxFVCg9oKrIeybHIIX4="; }}/apple/t2"
    ../files/hardware/hardware-configuration-macbook.nix
  ];

  hardware = {
    firmware = [
      (pkgs.stdenvNoCC.mkDerivation {
        name = "brcm-firmware";

        buildCommand = ''
          dir="$out/lib/firmware"
          mkdir -p "$dir"
echo "$dir"
          cp -r ${../files/firmware}/* "$dir"
        '';
      })
    ];

    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    opengl.enable = true;
    opengl.driSupport = true;
    opengl.driSupport32Bit = true;

    opengl.extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];

  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  #   boot.kernelParams = [ "hid_apple.swap_opt_cmd=1" "quiet" "udev.log_level=3" ];
  boot.kernelParams = [ "hid_apple.swap_opt_cmd=1" ];
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
  ];

  services.xserver = {
    xkb.layout = "us";
    libinput = {
      enable = true;
      touchpad = { disableWhileTyping = true; };
    };
  };

  users.users.takaobsid.packages = with pkgs; [
    wlr-randr
    nixfmt-classic
    gnome.sushi
    doublecmd
    joshuto
    rofi-wayland
    easyeffects
    grim
    slurp
    grimblast
    tmpwatch
    libqalculate
    pamixer
  ];

  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [ "zh_CN.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" ];
  };

  services.v2raya.enable = true;

  services.upower.enable = true;

  environment.variables = {
    NIXOS_OZONE_WL = "1";
    INPUT_METHOD = "fcitx5";
    XMODIFIERS = "@im=fcitx";
    WEBKIT_DISABLE_COMPOSITING_MODE = "1";
    RUST_BACKTRACE = "1";
  };

  services.xserver.desktopManager.runXdgAutostartIfNone = true;

  networking.proxy = {
    httpProxy = "http://127.0.0.1:1080";
    httpsProxy = "http://127.0.0.1:1080";
    allProxy = "socks5://127.0.0.1:1081";
  };

  # Creates /etc/current-system-packages with list of all packages with their versions
  environment.etc."current-system-packages".text = let
    packages = builtins.map (p: "${p.name}") config.environment.systemPackages;
    sortedUnique =
      builtins.sort builtins.lessThan (pkgs.lib.lists.unique packages);
    formatted = builtins.concatStringsSep "\n" sortedUnique;
  in formatted;
}
