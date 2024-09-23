{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # unstable.vue-language-server
  ];
}
