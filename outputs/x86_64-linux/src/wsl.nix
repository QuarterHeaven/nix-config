# outputs/x86_64-linux/src/wsl.nix
#
# ⚠️ 形参列表里的变量一个都不能删！
#    Haumea 懒传参，mylib.* 函数内部随时可能引用它们。
{
  inputs,
  lib,
  mylib,
  myvars,
  system,
  genSpecialArgs,
  ...
} @ args:
###############################################################################
# 1. 机器名 —— 与 flake.nix 中保持一致（首字母大写）
###############################################################################
let
  name = "wsl";

  shared = import ../../shared.nix { inherit inputs system; };

  modules = {
    nixos-modules =
      [
        inputs.nixos-wsl.nixosModules.wsl
      ]
      ++ (shared.common-modules or [])
      ++ (map mylib.relativeToRoot [
        "configuration.nix"
        "hosts/${name}.nix"
      ]);

    home-modules = [
      (mylib.relativeToRoot "modules/home-modules/${name}.nix")
    ];
  };

  systemArgs = modules // args;
in
  {
    nixosConfigurations.${name} = mylib.nixosSystem systemArgs;
  }
