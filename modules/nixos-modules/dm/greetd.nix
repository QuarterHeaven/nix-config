{ inputs, pkgs, ... }:
let
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
  gtkgreet = "${pkgs.greetd.gtkgreet}/bin/gtkgreet";

in {
  environment.systemPackages = with pkgs; [
    greetd.wlgreet
    greetd.tuigreet
    greetd.gtkgreet
  ];

  services.greetd = {
    enable = false;
    settings = rec {
      initial_session = {
        command = "${pkgs.hyprland}/bin/Hyprland";
        user = "takaobsid";
      };
      initial_session_hyprland_tui = {
        command =
          "${tuigreet} --greeting 'Welcome to NixOS!' --asterisks --remember --remember-user-session --time --cmd Hyprland";
        user = "greeter";
      };
      initial_session_hyprland_gtk = {
        command = "${gtkgreet} -c Hyprland";
        user = "greeter";
      };
      default_session = initial_session_hyprland_gtk;
    };
  };

  systemd.services.greetd = {
    environment = { LANG = "en_US.UTF-8"; };
    serviceConfig = {
      StandardInput = "tty";
      StandardOutput = "tty";
      TTYPath = "/dev/tty2";
      TTYReset = "yes";
      TTYVHangup = "yes";
      Type = "idle";
    };
  };
}
