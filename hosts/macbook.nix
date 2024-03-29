{ features, inputs, pkgs, ... }:

{
  networking.networkmanager.enable = true;

  imports =
    [ # Include the results of the hardware scan.
      ../files/hardware/hardware-configuration.nix
      "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; }}/apple/t2"
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
        cp -r ${./firmware}/* "$dir"
      '';
    })
  ];

  # Enable the KDE Plasma Desktop Environment.
#  services.xserver.displayManager.sddm.enable = true;
#  services.xserver.desktopManager.plasma5.enable = true;

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
    libinput.enable = true;
    xkb.options = "ctrl:swapcaps,altwin:meta_alt,altwin:hyper_win";
  };

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "takaobsid";

  environment.systemPackages = with pkgs; [
  ];

  services.v2raya.enable = true;

  home-manager.users.takaobsid = {
    imports = [
      ./macbook-home.nix
    ];
  };
}
