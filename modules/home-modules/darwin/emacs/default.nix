{ pkgs, ... }:

{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs.overrideAttrs
      (old: {
        patches = (old.patches or [ ]) ++ [
          # ./blur.patch
          ./fix-window-role.patch
          ./ns-alpha-background-2024-1-25-9b436cc.patch
          ./round-undecorated-frame.patch
          ./cursor-animation.patch
          # ./libgccjit-patch.patch
          ./poll.patch
          ./system-appearance.patch
        ];
      });
  };
}
