{
  description = "Taka's NixOS Flake";
  
  outputs = inputs: import ./outputs inputs;

  # Set Cache origin
  nixConfig = {
    experimental-features = [ "nix-command" "flakes" "pipe-operators"];
    substituters = [
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://cache.nixos.org/"
    ];

    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://aseipp-nix-cache.global.ssl.fastly.net"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];

    extra-platforms = [
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };

  inputs = {
    arion.url = "github:hercules-ci/arion";
    dotfiles = {
      # url = "git+file:///Users/takaobsid/nix-config/dotfiles";
      url = "path:./dotfiles";
      # flake = false;
    };
    # nixpkgs.url = "github:NixOS/nixpkgs/master";
    # nixpkgs.url = "github:QuarterHeaven/nixpkgs/master";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-unstable = { url = "github:nixos/nixpkgs/nixpkgs-unstable"; };
    home-manager = { url = "github:nix-community/home-manager"; inputs.nixpkgs.follows = "nixpkgs-unstable"; };
    emacs-overlay = { url = "github:nix-community/emacs-overlay"; inputs.nixpkgs.follows = "nixpkgs-unstable"; };
    nixos-wsl = { url = "github:nix-community/NixOS-WSL"; inputs.nixpkgs.follows = "nixpkgs"; };
    nixos-hardware = { url = "github:NixOS/nixos-hardware/master"; };
    across.url = "github:ArkToria/ACross";
    # hyprland = {
    #   type = "git";
    #   url = "https://github.com/hyprwm/Hyprland";
    #   submodules = true;
    # };
    # hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1&rev=9e781040d9067c2711ec2e9f5b47b76ef70762b3";
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = { url = "github:hyprwm/hyprland-plugins"; inputs.hyprland.follows = "hyprland"; };
    hyprgrass = { url = "github:horriblename/hyprgrass"; inputs.hyprland.follows = "hyprland"; };
    hyprslidr = { url = "gitlab:QuarterHeaven/hyprslidr"; inputs.hyprland.follows = "hyprland"; };
    luaposix = { url = "github:luaposix/luaposix/v36.3"; flake = false; };
    yazi.url = "github:sxyazi/yazi";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
    ags.url = "github:Aylur/ags";
    nur.url = "github:nix-community/NUR";
    niri = { url = "github:sodiboo/niri-flake"; };
    waybar = { url = "github:Alexays/Waybar"; };
    gestures.url = "github:riley-martin/gestures";
    xremap.url = "github:xremap/nix-flake";
    clipboard-sync.url = "github:QuarterHeaven/clipboard-sync";
    sops-nix.url = "github:Mic92/sops-nix";
    sketchybar-font-dist = { url = "https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v2.0.32/sketchybar-app-font.ttf"; flake = false; };
    sketchybar-font-src = { url = "github:kvndrsslr/sketchybar-app-font"; flake = false; };
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    my_tdlib = { url = "github:QuarterHeaven/my_tdlib"; };
    sbar_lua = { url = "path:./modules/flakes/SbarLua"; flake = true; };
    haumea = { url = "github:nix-community/haumea/v0.2.2"; inputs.nixpkgs.follows = "nixpkgs"; };
    pre-commit-hooks = { url = "github:cachix/pre-commit-hooks.nix"; inputs.nixpkgs.follows = "nixpkgs"; };
  };

  #   in
  #   {
  #     devModules = import ./dev.nix;

      # nixosConfigurations = {
      #   vmware = nixpkgs.lib.nixosSystem {
      #     inherit specialArgs;
      #     system = "x86_64-linux";

      #     modules = common-modules ++ [ ./hosts/vmware.nix ];
      #   };

      #   wsl = nixpkgs.lib.nixosSystem {
      #     inherit specialArgs;
      #     system = "x86_64-linux";

      #     modules = common-modules
      #       ++ [
      #       nixos-wsl.nixosModules.wsl
      #       hosts/wsl.nix
      #     ];
      #   };

      #   macbook = nixpkgs.lib.nixosSystem {
      #     inherit specialArgs;
      #     system = "x86_64-linux";

      #     modules = common-modules ++ [
      #       arion.nixosModules.arion
      #       nixos-hardware.nixosModules.apple-t2
      #       niri.nixosModules.niri
      #       xremap.nixosModules.default
      #       clipboard-sync.nixosModules.default
      #       nix-flatpak.nixosModules.nix-flatpak
      #       hosts/macbook.nix
      #     ];
      #   };

      #   minimal = nixpkgs.lib.nixosSystem {
      #     inherit specialArgs;
      #     system = "x86_64-linux";
      #     modules = [
      #       ./configuration-minimal.nix
      #       modules/nix-modules/desktop/gnome.nix
      #       modules/nix-modules/desktop/hyprland.nix
      #     ];
      #   };
      # };
}
