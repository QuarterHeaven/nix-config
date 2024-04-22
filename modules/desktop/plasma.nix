{ inputs, pkgs, ... }:

{
  services = {
    displayManager.sddm = {
      enable = false;
      wayland.enable = false;
    };

  };

  services.xserver.desktopManager.plasma5.enable = false;
}
