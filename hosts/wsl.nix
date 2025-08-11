{ features, inputs, home-manager, ... }:

{
  wsl = {
    enable = true;
    wslConf.automount.root = "/mnt";
    wslConf.interop.appendWindowsPath = false;
    wslConf.network.generateHosts = false;
    defaultUser = "takaobsid";
    startMenuLaunchers = true;

    # Enable integration with Docker Desktop (needs to be installed)
    docker-desktop.enable = false;
  };
  
  imports = [ # Include the results of the hardware scan.
    ../modules/nixos-modules/wsl/default.nix
  ];

  services.openssh = { ports = [ 2222 ]; };

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    autoPrune.enable = true;
  };

  home-manager.users.takaobsid = {
    imports = [ ../modules/home-modules/wsl.nix ];
  };

#   # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.xrdp = {
    enable = true;
    defaultWindowManager = "startplasma-x11";
    openFirewall = true;
    port = 3390;
  };

  services.openssh.settings.X11Forwarding = true;
  programs.ssh.forwardX11 = true;


    # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  environment.variables = {
    NIXOS_OZONE_WL = "1";
    INPUT_METHOD = "fcitx5";
    #    GTK_IM_MODULE = "wayland";
    WEBKIT_DISABLE_COMPOSITING_MODE = "1";
    RUST_BACKTRACE = "1";
    XMODIFIERS = "@im=fcitx";
    GTK_IM_MODULE="fcitx";
    QT_IM_MODULE="fcitx";
    SDL_IM_MODULE="fcitx";
    GLFW_IM_MODULE="fcitx";
    PATH = [
      "$PATH"
      "/home/takaobsid/bin"
      "/home/takaobsid/.local/share/applications"
    ];
    YDOTOOL_SOCKET="/run/user/$(id -u)/.ydotool_socket";
  };

    # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "taka";
}
