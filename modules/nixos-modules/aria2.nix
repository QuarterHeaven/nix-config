{ pkgs, ... }:

{
  environment.defaultPackages = with pkgs; [
    aria2
    ariang
  ];
  # services.aria2 = {
  #   enable = true;
  #   rpcListenPort = 6800;
  #   rpcSecretFile = "/home/takaobsid/.aria2rpc";
  #   downloadDir = "/home/takaobsid/Downloads";
  # };
}
