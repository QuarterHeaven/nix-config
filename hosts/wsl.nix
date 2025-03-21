{ features, inputs, home-manager, ... }:

{
  wsl = {
    enable = true;
    wslConf.automount.root = "/mnt";
    wslConf.interop.appendWindowsPath = false;
    wslConf.network.generateHosts = false;
    defaultUser = "taka";
    startMenuLaunchers = true;

    # Enable integration with Docker Desktop (needs to be installed)
    docker-desktop.enable = false;
  };

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
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

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
    layout = "us";
    xkbVariant = "";
  };

    # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "taka";
}
