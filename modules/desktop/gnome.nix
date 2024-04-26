{ inputs, pkgs, ... }:

{
  environment.systemPackages = with pkgs;
    with gnome; [
      gnome.adwaita-icon-theme
      adwaita-icon-theme
      gnome-text-editor
      gnome-calendar
      gnome-boxes
      gnome-system-monitor
      gnome-control-center
      gnome-weather
      gnome-calculator
      gnome-clocks
      gnome-software # for flatpak
      gnome-tweaks
      gnome-shell
      gnomeExtensions.runcat
      gnomeExtensions.tray-icons-reloaded
      gnome-extension-manager
    ];

  services.xserver = {
    displayManager.gdm.enable = true;
    displayManager.gdm.wayland = true;
    desktopManager.gnome.enable = true;
  };
}
