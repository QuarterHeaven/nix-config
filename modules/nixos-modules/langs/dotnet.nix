{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    dotnetCorePackages.sdk_9_0_3xx
  ];
}
