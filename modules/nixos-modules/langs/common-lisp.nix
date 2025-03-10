{ pkgs, ...}:

{
  environment.systemPackages = with pkgs; [
    sbc
  ];
}
