{
  inputs,
  lib,
  system,
  genSpecialArgs,
  nixos-modules,
  home-modules ? [ ],
  specialArgs ? (genSpecialArgs system),
  myvars,
  ...
}:
let
  inherit (inputs) nixpkgs nixpkgs-unstable home-manager;
  nixos-generators = inputs.nixos-generators or null;
in
nixpkgs.lib.nixosSystem {
  inherit system specialArgs;
  modules =
    nixos-modules
    ++ (lib.optionals (nixos-generators != null) [
      nixos-generators.nixosModules.all-formats
    ])
    ++ [
      (
        { lib, ... }:
        {
          nixpkgs.pkgs = import nixpkgs-unstable {
            inherit system; # refer the `system` parameter form outer scope recursively
            # To use chrome, we need to allow the installation of non-free software
            config.allowUnfree = true;
            config.allowBroken = true;
          };
        }
      )
    ]
    ++ (lib.optionals ((lib.lists.length home-modules) > 0) [
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "home-manager.backup";

        home-manager.extraSpecialArgs = specialArgs;
        home-manager.users."${myvars.username}".imports = home-modules;
      }
    ]);
}
