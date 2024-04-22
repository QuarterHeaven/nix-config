{ inputs, pkgs, ... }:
let tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";

  in {
    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      xwayland.enable = true;
    };

    services.flatpak.enable = true;

    security.pam.services.swaylock = { fprintAuth = false; };

    environment.systemPackages = with pkgs; [
      greetd.wlgreet
      greetd.tuigreet
      greetd.gtkgreet
      elogind
      where-is-my-sddm-theme
      swaylock
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
	default_session = initial_session;
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

    users.users.takaobsid.packages = with pkgs; [ hyprpaper ];

  }
