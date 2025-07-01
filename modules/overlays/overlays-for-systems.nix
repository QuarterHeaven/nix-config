{ system, inputs }:

[
  inputs.emacs-overlay.overlay
  (import ./mps-overlay.nix)
  (import ./emacs-mps-overlay.nix system)
]
