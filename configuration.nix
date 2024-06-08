# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, options, features, inputs, ... }:

{
  networking.hostName = "Manaward";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Configure GPU
  #services.xserver.videoDrivers = [ "nvidia" ];

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  programs.fish.enable = true;
  users.users.takaobsid = {
    isNormalUser = true;
    description = "TakaObsid";
    extraGroups = [ "networkmanager" "wheel" "docker" "users" "uinput" "input" ];
    packages = with pkgs; [
      firefox
      kate
      #  thunderbird
    ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMm976P3b0EigYG7VHxaORw1O4zFL2PvPZ7EUXw1MPRg liaotx2@gmail.com"
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [ "electron-11.5.0" ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall =
      true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall =
      true; # Open ports in the firewall for Source Dedicated Server
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    curl
    git
    git-credential-keepassxc
    helix
    fish
    pinentry
    nix-index
    (rust-bin.selectLatestNightlyWith (toolchain:
      toolchain.default.override {
        extensions = [ "rust-src" "rust-analyzer" ];
        targets = [ "wasm32-unknown-unknown" ];
      }))
    llvmPackages.libcxxClang
    llvmPackages.libcxxStdenv
    clang-tools
    libtool
    libdrm
    bintools
    gnumake
    cmake
    gcc-unwrapped
    libgcc
    pkg-config

    nix-output-monitor

    dive
    podman-tui
    # podman-compose
    docker-compose

    ueberzug # command-line image support
  ];

  # Font settings
  fonts.packages = with pkgs; [
    corefonts
    fira-code
    fira-code-symbols
    ibm-plex
    lxgw-wenkai
    liberation_ttf
    noto-fonts
    noto-fonts-cjk
    noto-fonts-color-emoji
    unifont_upper
    symbola
    font-awesome
    (nerdfonts.override { fonts = [ "FiraCode" "IBMPlexMono" ]; })
  ];

  fonts.fontconfig = {
    defaultFonts = {
      emoji = [ "Noto Color Emoji" ];
      monospace = [ "BlexMono Nerdfont Mono" ];
      sansSerif = [ "Bookerly" "FZLiuGongQuanKaiShuS" ];
      serif = [ "Bookerly" "FZLiuGongQuanKaiShuS" ];
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.hostKeys = options.services.openssh.hostKeys.default;

  systemd.services.tune-usb-autosuspend = {
    description = "Disable USB autosuspend";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = { Type = "oneshot"; };
    unitConfig.RequiresMountsFor = "/sys";
    script = ''
        echo -1 > /sys/module/usbcore/parameters/autosuspend
      '';
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
