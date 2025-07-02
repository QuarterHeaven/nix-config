# outputs/shared.nix
#
# 公共函数 / 变量，只写一次、所有系统共用。
{ inputs, system }:
let
  inherit (inputs) nixpkgs;

  ###################################
  ## 1. overlay 与 nixpkgs 封装
  ###################################
  add-unstable-packages-linux = _final: _prev: {
    unstable = import inputs.nixpkgs-unstable { system = "x86_64-linux"; };
  };

  add-unstable-packages-darwin = _final: _prev: {
    unstable = import inputs.nixpkgs-unstable { system = "aarch64-darwin"; };
  };

  universal_overlays = [
    inputs.emacs-overlay.overlay
    (import inputs.rust-overlay)
  ];

  overlaysFor = s: import ../modules/overlays/overlays-for-systems.nix {
    inherit inputs system;
  };

  nixpkgsWithOverlays = rec {
    overlays =
      universal_overlays
      ++ (if system == "x86_64-linux"  then [ add-unstable-packages-linux  ] else [])
      ++ (if system == "aarch64-darwin" then [ add-unstable-packages-darwin ] else [])
      ++ (overlaysFor system);
  };

  nixpkgsWithOverlaysDarwin = rec {
    overlays =
      universal_overlays
      ++ [ add-unstable-packages-darwin ]
      ++ (overlaysFor system);
  };

  ###################################
  ## 2. configurationDefaults* 封装
  ###################################
  configurationDefaults = extraArgs: {
    nixpkgs = {
      # config = {
      #   allowUnfree = true;
      #   allowBroken = true;
      #   permittedInsecurePackages = [ "electron-11.5.0" ];
      # };

      # inherit (nixpkgsWithOverlays) config;
      overlays = nixpkgsWithOverlays.overlays;
    };
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.extraSpecialArgs = extraArgs;
  };

  configurationDefaultsDarwin = extraArgs: {
    nixpkgs = {
      # config = {
      #   allowUnfree = true;
      #   allowBroken = true;
      #   permittedInsecurePackages = [ "electron-11.5.0" ];
      # };
      # inherit (nixpkgsWithOverlaysDarwin) config;
      overlays = nixpkgsWithOverlaysDarwin.overlays;
    };
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.extraSpecialArgs = extraArgs;
  };

  ###################################
  ## 3. 其他公共常量
  ###################################
  argDefaults = {
    inherit inputs;
    dotfiles = inputs.dotfiles;
  };

  common-modules = [
    ../configuration.nix
    inputs.home-manager.nixosModules.home-manager
    (configurationDefaults argDefaults)
    inputs.nur.modules.nixos.default
    inputs.sops-nix.nixosModules.sops
  ];
in {
  inherit overlaysFor
          nixpkgsWithOverlays
          nixpkgsWithOverlaysDarwin
          configurationDefaults
          configurationDefaultsDarwin
          argDefaults
          common-modules;
}
