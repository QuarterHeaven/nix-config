{
  lib,
  inputs,
  darwin-modules,
  home-modules ? [ ],
  myvars,
  system,
  genSpecialArgs,
  specialArgs ? (genSpecialArgs system),
  ...
}:
let
  inherit (inputs) nixpkgs-unstable home-manager nix-darwin;
in
nix-darwin.lib.darwinSystem {
  inherit system specialArgs;
  modules =
    darwin-modules
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
      home-manager.darwinModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "home-manager.backup";

        home-manager.extraSpecialArgs = specialArgs;
        home-manager.users."${myvars.username}".imports = home-modules;
      }
    ]);
}
