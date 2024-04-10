{ pkgs, ... }:

{
  home.packages = with pkgs;
    [
      (python311.withPackages (ps: with ps; [ pip virtualenv ]))
      # cudaPackages.cudatoolkit
    ];
}
