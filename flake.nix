{
  description = "Taka's NixOS Flake";

  # Set Cache origin
  nixConfig = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://cache.nixos.org/"
    ];

    extra-substituters = [ "https://nix-community.cachix.org" ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    dotfiles = {
      url = "path:./dotfiles";
      flake = false;
    };

    nixpkgs.url = "github:NixOS/nixpkgs/master";

    nixpkgs-unstable = {
      url = "github:nixos/nixpkgs/nixpkgs-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = { url = "github:NixOS/nixos-hardware/master"; };

    hyprland = { url = "github:hyprwm/Hyprland"; };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    hy3 = {
      url =
        "github:outfoxxed/hy3"; # where {version} is the hyprland release version
      # or "github:outfoxxed/hy3" to follow the development branch.
      # (you may encounter issues if you dont do the same for hyprland)
      inputs.hyprland.follows = "hyprland";
    };

    Hyprspace = {
      url = "github:KZDKM/Hyprspace";
      inputs.hyprland.follows = "hyprland";
    };

    hyprgrass = {
      url = "github:horriblename/hyprgrass";
      inputs.hyprland.follows = "hyprland"; # IMPORTANT
    };

    flake-utils.url = "github:numtide/flake-utils";

    rust-overlay.url = "github:oxalica/rust-overlay";

    ags.url = "github:Aylur/ags";

    nur.url = "github:nix-community/NUR";

    niri = {
      url = "github:sodiboo/niri-flake";
    };
  };

  outputs = { self, nixpkgs, nix, home-manager, emacs-overlay, nixos-wsl
    , nixos-hardware, hyprland, hy3, flake-utils, rust-overlay, nixpkgs-unstable
    , dotfiles, nur, niri, hyprgrass, ... }@inputs:
    let
      specialArgs = { inherit inputs; };

      add-unstable-packages = final: _prev: {
        unstable = import inputs.nixpkgs-unstable { system = "x86_64-linux"; };
      };

      nixpkgsWithOverlays = with inputs; rec {
        config = {
          allowUnfree = true;
          permittedInsecurePackages = [ ];
        };
        overlays = [
          emacs-overlay.overlay
          (self: super: {
            emacs-unstable = super.emacs-unstable.override {
              withXwidgets = true;
              withGTK3 = true;
            };
          })

          add-unstable-packages

          (import rust-overlay)

          (final: prev: {
            rofi-calc = prev.rofi-calc.override {
              rofi-unwrapped = prev.rofi-wayland-unwrapped;
            };
          })

	  niri.overlays.niri
        ];
      };

      configurationDefaults = args: {
        nixpkgs = nixpkgsWithOverlays;
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = args;
      };

      argDefaults = { inherit inputs dotfiles; };

      common-modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        (configurationDefaults argDefaults)

	nur.nixosModules.nur
        # This adds a nur configuration option.
        # Use `config.nur` for packages like this:
        # ({ config, ... }: {
        #   environment.systemPackages = [ config.nur.repos.mic92.hello-nur ];
        # })
      ];

    in {
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
            ++ [ nixos-wsl.nixosModules.wsl ./hosts/wsl.nix ];
        };

        macbook = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "x86_64-linux";

          modules = common-modules
            ++ [ nixos-hardware.nixosModules.apple-t2
	      niri.nixosModules.niri
	      hosts/macbook.nix ];
        };

        minimal = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "x86_64-linux";
          modules = [
            ./configuration-minimal.nix
            modules/desktop/gnome.nix
            modules/desktop/hyprland.nix
          ];
        };
      };
    };
}
