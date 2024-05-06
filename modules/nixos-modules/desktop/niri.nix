{ pkgs, inputs, ...}:

{
  # nixpkgs.overlays = [niri.overlays.niri];
  programs.niri = {
    enable = true;
    # package = inputs.niri.packages.${pkgs.system}.niri-stable;
    package = pkgs.niri-unstable;
  };

  users.users.takaobsid.packages = with pkgs; [
    alacritty
  ]; 

  # services.xserver.displayManager.session = [
  #   {
  #     manage = "desktop";
  #     name = "Niri";
  #     exec = ''
  #       ${pkgs.niri}/bin/niri-session
  #     '';
  #   }
  # ];
}
