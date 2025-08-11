# overlays/trace-default-emacs.nix
final: prev: {
  emacs = builtins.trace (builtins.traceVal "⚠️  pkgs.emacs referenced → inspect who pulled in emacs-30.1") prev.emacs;
}
