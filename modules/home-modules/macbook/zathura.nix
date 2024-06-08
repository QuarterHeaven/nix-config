{ ... }:

{
  programs.zathura = {
    enable = true;
    extraConfig = ''
      set recolor-keephue true
      set recolor true
    '';
  };
}
