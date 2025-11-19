# outputs/x86_64-linux/src/wsl.nix
{
  inputs,
  lib,
  mylib,
  myvars,
  system,
  genSpecialArgs,
  ...
} @ args:
let
  name = "wsl";

  shared = import ../../shared.nix { inherit inputs system; };

  modules = {
    nixos-modules =
      [
        inputs.home-manager.nixosModules.home-manager
        (shared.configurationDefaults shared.argDefaults)
        inputs.nixos-wsl.nixosModules.wsl
        inputs.nur.modules.nixos.default
        inputs.sops-nix.nixosModules.sops
      ]
      ++ (map mylib.relativeToRoot [
        "configuration.nix"
        "hosts/wsl.nix"
      ]);

    # 如需 HM 用户侧模块可在此追加
    home-modules = [ ];
  };

  systemArgs = modules // args;
in
{
  nixosConfigurations.${name} =
    mylib.nixosSystem systemArgs;
}

