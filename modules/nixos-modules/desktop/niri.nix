{ pkgs, inputs, ... }:

{
  nixpkgs.overlays = [inputs.niri.overlays.niri];
  programs.niri = {
    enable = true;
    # package = inputs.niri.packages.${pkgs.system}.niri-stable;
    package = pkgs.niri-unstable;
  };

  environment.variables.NIXOS_OZONE_WL = "1";
  environment.systemPackages = with pkgs; [
    wl-clipboard
    wayland-utils
    libsecret
    cage
    gamescope
  ];
  # qt.enable = true;
  # qt.style = "adwaita-dark";
  # qt.platformTheme = "gnome";

  users.users.takaobsid.packages = with pkgs; [ alacritty ];
}
