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
    arion.url = "github:hercules-ci/arion";

    dotfiles = {
      url = "path:./dotfiles";
      flake = false;
    };

    # nixpkgs.url = "github:NixOS/nixpkgs/master";
    # nixpkgs.url = "github:QuarterHeaven/nixpkgs/master";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.05-darwin";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

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

    across.url = "github:ArkToria/ACross";

    # hyprland = {
    #   type = "git";
    #   url = "https://github.com/hyprwm/Hyprland";
    #   submodules = true;
    # };
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1&rev=9e781040d9067c2711ec2e9f5b47b76ef70762b3";

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    hyprgrass = {
      url = "github:horriblename/hyprgrass";
      inputs.hyprland.follows = "hyprland";
    };

    hyprslidr = {
      url = "gitlab:QuarterHeaven/hyprslidr";
      inputs.hyprland.follows = "hyprland";
    };

    hyprscroller = {
      url = "github:dawsers/hyprscroller";
      inputs.hyprland.follows = "hyprland";
    };

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

    nix-flatpak.url = "github:gmodena/nix-flatpak";
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
    , hyprscroller
    , nix-darwin
    , ...
    }@inputs:
    let
      specialArgs = { inherit inputs; };

      add-unstable-packages-linux = final: _prev: {
        unstable = import inputs.nixpkgs-unstable { system = "x86_64-linux"; };
      };

      add-unstable-packages-darwin = final: _prev: {
        unstable = import inputs.nixpkgs-unstable { system = "x86_64-darwin"; };
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

          add-unstable-packages-linux

          (import rust-overlay)

          (final: prev: {
            rofi-calc = prev.rofi-calc.override {
              rofi-unwrapped = prev.rofi-wayland-unwrapped;
            };
          })

          niri.overlays.niri
        ];
      };

      nixpkgsWithOverlaysDarwin =  with inputs; rec {
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

	  add-unstable-packages-darwin

	  (import rust-overlay)
	];
      };
      
      configurationDefaults = args: {
        nixpkgs = nixpkgsWithOverlays;
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = args;
      };

      configurationDefaultsDarwin = args: {
	nixpkgs = nixpkgsWithOverlaysDarwin;
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
            ++ [ nixos-wsl.nixosModules.wsl ./hosts/wsl.nix ];
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
              modules/desktop/gnome.nix
              modules/desktop/hyprland.nix
            ];
          };
	};

	darwinConfigurations."Leyline" = nix-darwin.lib.darwinSystem {
          inherit specialArgs;
          system = "x86_64-darwin";
          modules = [
            home-manager.darwinModules.home-manager
            (configurationDefaultsDarwin argDefaults)
	              
            ./configuration-darwin.nix
            hosts/darwin.nix
          ];
	};
      };
}
