{ features, inputs, pkgs, config, ... }:
let
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
  sway-session = "${pkgs.sway}/share/wayland-sessions";
  wayfire-session = "${pkgs.wayfire}/share/wayland-sessions";

  in {
    networking.networkmanager = {
      enable = true;
      unmanaged = [ "type:ethernet" ];
    };

    imports = [ # Include the results of the hardware scan.
      ../files/hardware/hardware-configuration-macbook.nix
    ];

    hardware = {
      firmware = [
	(pkgs.stdenvNoCC.mkDerivation {
	  name = "brcm-firmware";

	  buildCommand = ''
          dir="$out/lib/firmware"
          mkdir -p "$dir"
          cp -r ${../files/firmware}/* "$dir"
        '';
	})
      ];
    };

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.efi.efiSysMountPoint = "/boot/efi";
    boot.kernelParams = [ "hid_apple.swap_opt_cmd=1" "quiet" "udev.log_level=3" ];
    boot.plymouth.enable = true;
    boot.plymouth.theme = "breeze";
    boot.initrd.verbose = false;
    boot.consoleLogLevel = 0;

    environment.systemPackages = with pkgs; [
      gnome.gnome-tweaks
      gnomeExtensions.runcat
      gnomeExtensions.tray-icons-reloaded
      gnome-extension-manager
      solaar
      keyd
      libinput
      greetd.wlgreet
      greetd.tuigreet
      elogind
      lemurs # text-based login manager
      pavucontrol
      mesa
    ];

    services.xserver = {
      enable = true;
      xkb.layout = "us";
      libinput = {
	enable = true;
	touchpad = { disableWhileTyping = true; };
      };
    };

    services.greetd = {
      enable = true;
      settings = rec {
	auto_login = {
	  command = "${pkgs.wayfire}/bin/wayfire";
	  user = "takaobsid";
	};
	initial_session_wayfire = {
	  command = "wayfire --config /etc/greetd/wlgreet-wayfire.ini";
	};
	initial_session_sway = {
	  command = "sway --config /etc/greetd/wlgreet-sway.conf";
	};
	initial_session_sway_tui = {
	  command = "${tuigreet} --time --cmd sway";
	  user = "greeter";
	};
	initial_session_wayfire_tui = {
	  command = "${tuigreet} --time --cmd wayfire";
	  user = "greeter";
	};
        initial_session_hyprland_tui = {
	  command = "${tuigreet} --time --cmd Hyprland";
	  user = "takaobsid";
	};
	default_session = initial_session_hyprland_tui;
      };
    };

    systemd.services.greetd = {
      environment = { LANG = "en_US.UTF-8"; };
      serviceConfig = {
	StandardInput = "tty";
	StandardOutput = "tty";
	TTYPath = "/dev/tty2";
	TTYReset = "yes";
	TTYVHangup = "yes";
	Type = "idle";
      };
    };

    programs.hyprland = {
      enable = false;
      xwayland.enable = true;
    };

    users.users.takaobsid.packages = with pkgs; [
      wlr-randr
      nixfmt-classic
      gnome.sushi
      doublecmd
      joshuto
      rofi-wayland
      hyprpaper
      easyeffects
      grim
      slurp
      grimblast
      tmpwatch
    ];

    i18n = {
      defaultLocale = "en_US.UTF-8";
      supportedLocales = [ "zh_CN.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" ];
    };

    services.v2raya.enable = true;

    environment.variables = {
      NIXOS_OZONE_WL = "1";
      INPUT_METHOD="fcitx5";
      XMODIFIERS = "@im=fcitx";
      WEBKIT_DISABLE_COMPOSITING_MODE = "1";
    };

    services.xserver.desktopManager.runXdgAutostartIfNone = true;

    home-manager.users.takaobsid = { imports = [ ./macbook-home.nix ]; };

    # Creates /etc/current-system-packages with list of all packages with their versions
    environment.etc."current-system-packages".text =
      let
	packages = builtins.map (p: "${p.name}") config.environment.systemPackages;
	sortedUnique = builtins.sort builtins.lessThan (pkgs.lib.lists.unique packages);
	formatted = builtins.concatStringsSep "\n" sortedUnique;
	in
	formatted;
  }
