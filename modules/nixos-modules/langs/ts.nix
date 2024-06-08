{ pkgs, config, ... }:

{
  environment.defaultPackages = with pkgs; [
    typescript
    nodePackages.typescript-language-server
  ];
}
