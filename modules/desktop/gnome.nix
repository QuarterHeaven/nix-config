{ inputs, pkgs, ... }:

{
  services.xserver = {
    displayManager.gdm.enable = true;
    displayManager.gdm.wayland = true;
    desktopManager.gnome.enable = true;
  };
}
