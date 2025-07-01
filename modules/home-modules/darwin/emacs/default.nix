{ pkgs, ... }:

let
  emacsPkg = pkgs.emacs-master-pgtk-with-igc;
in
{
  programs.emacs = {
    enable = true;
    # package = pkgs.gtkEmacsMPS.overrideAttrs
    #   (old: {
    #     patches = (old.patches or [ ]) ++ [
    #       # ./blur.patch
    #       #./fix-window-role.patch
    #       #./ns-alpha-background-2024-1-25-9b436cc.patch
    #       # ./round-undecorated-frame.patch
    #       # ./cursor-animation.patch
    #       # ./libgccjit-patch.patch
    #       # ./poll.patch
    #       # ./system-appearance.patch
    #       ./patches-31/fix-window-role.patch          
    #       ./patches-31/ns-alpha-background.patch      
    #       ./patches-31/ns-mac-input-source.patch      
    #       ./patches-31/round-undecorated-frame.patch  
    #       ./patches-31/system-appearance.patch
    #     ];
    #   });
    package = emacsPkg;
  };
}
