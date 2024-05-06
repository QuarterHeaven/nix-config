{ features, ... }:

{
  networking.networkmanager.enable = true;

  imports = [ # Include the results of the hardware scan.
    ../hard-files/hardware/hardware-configuration.nix
  ];
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "taka";

  environment.systemPackages = with pkgs; [ open-vm-tools ];

  virtualisation.vmware.guest.enable = true;

  home-manager.users.takaobsid = { imports = [ ./vmware.nix ]; };
}
