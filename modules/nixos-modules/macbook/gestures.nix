{ inputs, pkgs, ... }:

{
  users.users.takaobsid.packages = [
    inputs.gestures.packages.${pkgs.system}.gestures
    pkgs.ydotool
    pkgs.xdotool
    pkgs.fusuma
  ];

  # systemd.user.services."gestures" = {
  #   description = "Touchpad Gestures(with 3-finger drag performance improvements)";
  #   documentation = ["https://github.com/ferstar/gestures"];
  #   enable = true;
  #   serviceConfig = {
  #     Type = "simple";
  #     User = "takaobsid";
  #     ExecStart = ''gestures start'';
  #     ExecReload = ''gestures reload'';
  #     Restart = "no";
  #   };
  #   wantedBy = ["default.target"];
  # };

}
