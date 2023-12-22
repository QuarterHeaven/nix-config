{
  description = "Taka's NixOS Flake";

  # Set Cache origin
  nixConfig = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://cache.nixos.org/"
    ];

    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, emacs-overlay, nixos-wsl, ... }@inputs:
  let
    features = ./features;
    dotfiles = ./dotfiles;
    host_wsl = ./hosts/wsl-home.nix;
    host_vmware = ./hosts/vmware-home.nix;

    nixpkgsWithOverlays = with inputs; rec {
      config = {
        allowUnfree = true;
        permittedInsecurePackages = [];
      };
      overlays = [
        emacs-overlay.overlay
        (self: super: {
          emacs-unstable = super.emacs-unstable.override {
            withXwidgets = true;
            withGTK3 = true;
          };
        })
      ];
    };

    configurationDefaults = args : {
      nixpkgs = nixpkgsWithOverlays;
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = args;
    };

    argDefaults = {
      inherit inputs dotfiles features;
    };
    in
    {
      devModules = import ./dev.nix;

      nixosConfigurations = {
	vmware = nixpkgs.lib.nixosSystem{
          system = "x86_64-linux";

          modules = [
            ./configuration.nix

	    home-manager.nixosModules.home-manager

            (configurationDefaults argDefaults)

            ./hosts/vmware.nix
	  ];
	};

	wsl = nixpkgs.lib.nixosSystem{
          system = "x86_64-linux";

          modules = [
            ./configuration.nix

            nixos-wsl.nixosModules.wsl

	    home-manager.nixosModules.home-manager

            (configurationDefaults argDefaults)

	    ./hosts/wsl.nix
          ];
	};
      };
    };
}
