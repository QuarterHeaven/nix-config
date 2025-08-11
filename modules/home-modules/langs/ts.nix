{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    typescript
    nodePackages.typescript-language-server
  ];
}
