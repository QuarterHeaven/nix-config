{ features, inputs, pkgs, ... }:

{
  networking.networkmanager.enable = true;

  imports =
    [ # Include the results of the hardware scan.
      ../files/hardware/hardware-configuration-macbook.nix
      "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git";
      rev = "9a763a7acc4cfbb8603bb0231fec3eda864f81c0"; }}/apple/t2"
    ];
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  hardware.firmware = [
    (pkgs.stdenvNoCC.mkDerivation {
      name = "brcm-firmware";

      buildCommand = ''
        dir="$out/lib/firmware"
        mkdir -p "$dir"
        cp -r ${../files/firmware}/* "$dir"
      '';
    })
  ];

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = false;
  services.xserver.desktopManager.plasma5.enable = false;

  services.xserver.displayManager.gdm.enable = false;
  services.xserver.desktopManager.gnome.enable = false;

  programs.wayfire = {
    enable = true;
    plugins = with pkgs.wayfirePlugins; [
      wcm
      wf-shell
      wayfire-plugins-extra
    ];
  };

  programs.sway = {
    enable = false;
    wrapperFeatures.gtk = true;
  };

  programs.hyprland = {
    enable = false;
    xwayland.enable = true;
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
    libinput = {
      enable = true;
      touchpad = {
        disableWhileTyping = true;
      };
    };
  };

  services.keyd = {
    enable = true;
    keyboards =
      {
	default = {
	  ids = [ "*" ];
	  settings = {
	    main = {
	      capslock = "layer(control)";
	      leftcontrol = "capslock";
	    };
	  };
	};
	macbookKeyboard = {
	  ids = [ "05ac:027e" ];
	  settings = {
	    main = {
	      leftalt = "layer(meta)";
	      leftmeta = "layer(alt)";
	      capslock = "layer(control)";
	      leftcontrol = "capslock";
	    };
	    alt = {
	      e = "command(emacs)";
	    };
	  };
	};
      };
  };

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "takaobsid";

  environment.systemPackages = with pkgs; [
    gnome.gnome-tweaks
    gnomeExtensions.runcat
    gnomeExtensions.tray-icons-reloaded
    gnome-extension-manager
    solaar
    ibus
    ibus-engines.rime
    keyd
    libinput
  ];

  users.users.takaobsid.packages = with pkgs; [
    wlr-randr
  ];

  i18n.inputMethod = {
    enabled = "ibus";
    ibus.engines = with pkgs.ibus-engines; [ rime ];
  };

  services.v2raya.enable = true;

  environment.variables = {
    GTK_IM_MODULE="ibus";
    XMODIFIERS="@im=ibus";
    QT_IM_MODULE="ibus";
    XIM_PROGRAM="ibus-daemon";
    ELECTRON_OZONE_PLATFORM_HINT="auto";
  };

  home-manager.users.takaobsid = {
    imports = [
      ./macbook-home.nix
    ];
  };
}
