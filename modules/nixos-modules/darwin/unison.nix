{ inputs, pkgs, config, lib, ... }:

let
  onedriveOrg = "/Users/takaobsid/Library/CloudStorage/OneDrive-MSFT/orgs";
  icloudOrg = "/Users/takaobsid/Library/Mobile Documents/iCloud~com~appsonthemove~beorg/Documents/orgs";
  in
  {
    environment.systemPackages = with pkgs; [
      unison-fsmonitor
    ];

    launchd.agents."com.takaobsid.unison.orgs" = {
      ### 直接声明 plist 里的 Key/Value
      serviceConfig = {
        Label            = "com.takaobsid.unison.orgs";
        ProgramArguments = lib.mkForce [
          "${pkgs.unison}/bin/unison"
          "orgs"
        ];
        RunAtLoad        = true;  # 登录后立刻跑
        KeepAlive        = true;  # 进程退出时自动重启
        WatchPaths       = [ onedriveOrg icloudOrg ];  # 依赖 watchPaths 再次触发
        StandardOutPath  = "/tmp/unison-launchd.out";
        StandardErrorPath= "/tmp/unison-launchd.err";
      };
    };
  }
