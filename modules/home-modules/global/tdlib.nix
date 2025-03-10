{ inputs, pkgs, ... }:

{
  home.packages = with pkgs; [
    inputs.my_tdlib.packages.${pkgs.system}.default
  ];

  home.file.".tdlib".source = "${inputs.my_tdlib.packages.${pkgs.system}.default}";
}
