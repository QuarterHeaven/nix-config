{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ lemminx ];
}
