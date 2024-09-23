{ pkgs, config, ... }:

{
  environment.systemPackages = with pkgs; [
    typescript
    nodePackages.typescript-language-server
  ];
}
