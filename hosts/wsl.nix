{ config, lib, pkgs, features, ... }:

{
  networking.hostName = "wsl";
  imports = [
    <nixos-wsl/modules>
    # /${features}/global
  ];

  wsl.enable = true;
  wsl.defaultUser = "taka";
}
