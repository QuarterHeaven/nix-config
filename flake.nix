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

    hyprland = {
      url = "github:hyprwm/Hyprland";
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    hy3 = {
      url = "github:outfoxxed/hy3"; # where {version} is the hyprland release version
      # or "github:outfoxxed/hy3" to follow the development branch.
      # (you may encounter issues if you dont do the same for hyprland)
      inputs.hyprland.follows = "hyprland";
    };

    Hyprspace = {
      url = "github:KZDKM/Hyprspace";
      inputs.hyprland.follows = "hyprland";
    };

    flake-utils.url = "github:numtide/flake-utils";

    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, nixpkgs, nix, home-manager, emacs-overlay, nixos-wsl
  , nixos-hardware, hyprland, hy3, flake-utils, rust-overlay, nixpkgs-unstable, ... }@inputs:
    let
      home = ./home;
      dotfiles = ./dotfiles;
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
        ];
      };

      configurationDefaults = args: {
        nixpkgs = nixpkgsWithOverlays;
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = args;
      };

      argDefaults = { inherit inputs dotfiles home; };

common-modules = [
	./configuration.nix
	home-manager.nixosModules.home-manager
	(configurationDefaults argDefaults)
];

      in {
	devModules = import ./dev.nix;

	nixosConfigurations = {
          vmware = nixpkgs.lib.nixosSystem {
	    inherit specialArgs;
            system = "x86_64-linux";

            modules = common-modules ++ [
              ./hosts/vmware.nix
	      ./home/vmware.nix
            ];
          };

          wsl = nixpkgs.lib.nixosSystem {
	    inherit specialArgs;
            system = "x86_64-linux";

            modules = common-modules ++ [
              nixos-wsl.nixosModules.wsl
              ./hosts/wsl.nix
	      ./home/wsl.nix
            ];
          };

          macbook = nixpkgs.lib.nixosSystem {
	    inherit specialArgs;
            system = "x86_64-linux";

            modules = common-modules ++ [
              nixos-hardware.nixosModules.apple-t2
	      ./hosts/macbook.nix
	      ./modules/desktop/gnome.nix
	      ./modules/desktop/hyprland.nix
		./modules/desktop/wayfire.nix
		./modules/desktop/plasma.nix
	      ./home/macbook.nix
            ];
          };
	};
      };
}
