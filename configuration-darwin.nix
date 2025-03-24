# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, options, features, inputs, ... }:

{
  networking.hostName = "Leyline";

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # nix.settings.substituters = [ "https://mirror.sjtu.edu.cn/nix-channels/store" ];

  nixpkgs.hostPlatform = "aarch64-darwin";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.takaobsid = {
    name = "takaobsid";
    home = "/Users/takaobsid";
    uid = 501;
    description = "TakaObsid";
    packages = with pkgs; [
      # firefox
      # kate
      #  thunderbird
    ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMm976P3b0EigYG7VHxaORw1O4zFL2PvPZ7EUXw1MPRg liaotx2@gmail.com"
    ];
  };

  users.knownUsers = [ "takaobsid" ];

  programs.zsh.enable = true;
  programs.fish.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # nixpkgs.config.permittedInsecurePackages = [ "electron-11.5.0" ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    curl
    git
    git-credential-keepassxc
    helix
    nix-index
    # (rust-bin.selectLatestNightlyWith (toolchain:
    #   toolchain.default.override {
    #     extensions = [ "rust-src" "rust-analyzer" ];
    #     targets = [ "wasm32-unknown-unknown" ];
    #   }))
    llvmPackages.libcxxClang
    llvmPackages.libcxxStdenv
    clang-tools
    libgccjit
    cmake
    gdb

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
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    unifont_upper
    # symbola
    font-awesome
    nerd-fonts.fira-code
    nerd-fonts.blex-mono
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  security.pam.services.sudo_local.touchIdAuth = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  # system.stateVersion = "24.05"; # Did you read the comment?
  system.stateVersion = 4;
  ids.gids.nixbld = 350;
}
