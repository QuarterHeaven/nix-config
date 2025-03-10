{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    tdlib_src = {
      flake = false;
      url = "github:tdlib/td";
    };
  };

  outputs = {self, nixpkgs, tdlib_src, ...}@inputs: let
    forAllSys = nixpkgs.lib.genAttrs nixpkgs.lib.platforms.all;
    in {
      packages = forAllSys (system:
let
  pkgs = import nixpkgs { inherit system; };
  stdenv = pkgs.stdenv;
  my_tdlib = pkgs.callPackage ./default.nix {
    inherit stdenv;
    tdlib_src = tdlib_src;
  };
  in {
    default = my_tdlib;
  });
    };
}
