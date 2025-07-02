# outputs/aarch64-darwin/src/leyline.nix
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
  name = "Leyline";

  shared = import ../../shared.nix { inherit inputs system; };
  
  modules = {
    darwin-modules =
      [
        inputs.home-manager.darwinModules.home-manager
        (shared.configurationDefaultsDarwin shared.argDefaults)
      ]

      ++ (map mylib.relativeToRoot [
        "configuration-darwin.nix"
        "hosts/darwin-${name}.nix"
        "modules/assertions/no-default-emacs.nix"
      ]);

    home-modules = [ ];
  };

  systemArgs = modules // args;
in
  {
    darwinConfigurations.${name} = mylib.macosSystem systemArgs;
  }
