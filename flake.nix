{
  description = "Taka's NixOS Flake";

  # Set Cache origin
  nixConfig = {
    experimental-features = [ "nix-command" "flakes" ];
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
  };

  outputs =
    { self
    , nixpkgs
    , nix
    , home-manager
    , emacs-overlay
    , nixos-wsl
    , nixos-hardware
    , hyprland
    , flake-utils
    , rust-overlay
    , nixpkgs-unstable
    , dotfiles
    , nur
    , niri
    , hyprgrass
    , hyprslidr
    , waybar
    , yazi
    , gestures
    , across
    , xremap
    , clipboard-sync
    , arion
    , sops-nix
    , nix-flatpak
    , nix-darwin
    , my_tdlib
    , sbar_lua
    , ...
    }@inputs:
    let
      specialArgs = { inherit inputs; };

      add-unstable-packages-linux = final: _prev: {
        unstable = import inputs.nixpkgs-unstable { system = "x86_64-linux"; };
      };

      add-unstable-packages-darwin = final: _prev: {
        unstable = import inputs.nixpkgs-unstable { system = "aarch64-darwin"; };
      };

      # mylib = import ./lib { inherit lib; };

      universal_overlays = [
        emacs-overlay.overlay
        # (self: super: {
        #   emacs-unstable = super.emacs-unstable.override {
        #     withXwidgets = true;
        #     withGTK3 = true;
        #   };
        # })

        (import rust-overlay)

      #   (
      #     final: prev:
      # let
      #   sources = prev.callPackage modules/pkgs/_sources/generated.nix { };
      # in
      #   mylib.callPackageFromDirectory {
      #     callPackage = prev.lib.callPackageWith (prev // sources);
      #     directory = modules/pkgs;
      #   }
        )
      ];

      overlaysFor = system: import ./modules/overlays/overlays-for-systems.nix {
inherit system inputs;
};

      nixpkgsWithOverlays = with inputs; rec {
        config = {
          allowUnfree = true;
          permittedInsecurePackages = [ ];
        };
        overlays = universal_overlays ++ [
          add-unstable-packages-linux

          (final: prev: {
            rofi-calc = prev.rofi-calc.override {
              rofi-unwrapped = prev.rofi-wayland-unwrapped;
            };
          })

          niri.overlays.niri
        ];
      };

      nixpkgsWithOverlaysDarwin = with inputs; rec {
        config = {
          allowUnfree = true;
          permittedInsecurePackages = [ ];
        };
        overlays = universal_overlays ++ [
          add-unstable-packages-darwin
        ];
      };

      configurationDefaults = args: {
        # nixpkgs = nixpkgsWithOverlays;
	nixpkgs = {
        inherit (nixpkgsWithOverlays) config;
        overlays = nixpkgsWithOverlays.overlays ++ overlaysFor "x86_64-linux";
      };
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = args;
      };

      configurationDefaultsDarwin = args: {
        # nixpkgs = nixpkgsWithOverlaysDarwin;
	nixpkgs = {
        inherit (nixpkgsWithOverlaysDarwin) config;
        overlays = nixpkgsWithOverlaysDarwin.overlays ++ overlaysFor "aarch64-darwin";
      };

        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = args;
      };

      argDefaults = { inherit inputs dotfiles; };

      common-modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        (configurationDefaults argDefaults)

        nur.modules.nixos.default
        # This adds a nur configuration option.
        # Use `config.nur` for packages like this:
        # ({ config, ... }: {
        #   environment.systemPackages = [ config.nur.repos.mic92.hello-nur ];
        # })

        sops-nix.nixosModules.sops
      ];
    in
    {
      devModules = import ./dev.nix;

      nixosConfigurations = {
        vmware = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "x86_64-linux";

          modules = common-modules ++ [ ./hosts/vmware.nix ];
        };

        wsl = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "x86_64-linux";

          modules = common-modules
            ++ [
            nixos-wsl.nixosModules.wsl
            hosts/wsl.nix
          ];
        };

        macbook = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "x86_64-linux";

          modules = common-modules ++ [
            arion.nixosModules.arion
            nixos-hardware.nixosModules.apple-t2
            niri.nixosModules.niri
            xremap.nixosModules.default
            clipboard-sync.nixosModules.default
            nix-flatpak.nixosModules.nix-flatpak
            hosts/macbook.nix
          ];
        };

        minimal = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "x86_64-linux";
          modules = [
            ./configuration-minimal.nix
            modules/nix-modules/desktop/gnome.nix
            modules/nix-modules/desktop/hyprland.nix
          ];
        };
      };

      darwinConfigurations."Leyline" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";

        specialArgs = {
          inherit inputs;
          pkgs-unstable = nixpkgs-unstable.legacyPackages.aarch64-darwin;
        };

        modules = [
          home-manager.darwinModules.home-manager
          (configurationDefaultsDarwin argDefaults)

          ./configuration-darwin.nix
          hosts/darwin.nix
          ./modules/assertions/no-default-emacs.nix
        ];
      };
    };
}
