{ inputs, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ where-is-my-sddm-theme ];

  services = {
    displayManager.sddm = {
      enable = false;
      wayland.enable = true;
    };

  };

  services.xserver.desktopManager.plasma5.enable = false;
}
