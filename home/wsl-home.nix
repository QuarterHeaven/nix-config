{ config, lib, pkgs, features, inputs, dotfiles, ... }:

{
  imports = [
    # <nixos-wsl/modules>
    ../modules/global
    ../modules/wsl
    ./home.nix
  ];

  home.sessionVariables = rec {
    DISPLAY = "`cat /etc/resolv.conf | grep nameserver | awk '{print $2}'`:0.0";
  };
}
