{ inputs, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # inputs.my_tdlib.packages.${pkgs.system}.default
    # tdlib
    zlib.dev
  ];

  # home.file.".tdlib".source = "${inputs.my_tdlib.packages.${pkgs.system}.default}";
  # home.file.".tdlib".source = pkgs.tdlib;
}
