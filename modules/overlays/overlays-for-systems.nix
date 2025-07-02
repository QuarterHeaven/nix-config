{ system, inputs }:

[
  inputs.emacs-overlay.overlay
  (import ./mps-overlay.nix)
  (import ./emacs-mps-overlay.nix system)
  (
    final: prev:
      let
        sources = prev.callPackage ../pkgs/_sources/generated.nix { };
        mylib = import ../../lib { inherit (prev) lib; };

      in
        mylib.callPackageFromDirectory {
          callPackage = prev.lib.callPackageWith (prev // sources);
          directory = ../pkgs;
        }
  )
]
