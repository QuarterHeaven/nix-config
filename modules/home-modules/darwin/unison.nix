{ inputs, pkgs, config, lib, ... }:

let
  onedriveOrg = "/Users/takaobsid/Library/CloudStorage/OneDrive-MSFT/orgs";
  icloudOrg = "/Users/takaobsid/Library/Mobile Documents/iCloud~com~appsonthemove~beorg/Documents/orgs";
  in
  {
    home.packages = with pkgs; [
      unison-fsmonitor
    ];

    launchd.enable = true;
    launchd.agents."com.takaobsid.unison.orgs" = {
      enable = true;
      ### 直接声明 plist 里的 Key/Value
      config = {
        Label            = "com.takaobsid.unison.orgs";
        ProgramArguments = lib.mkForce [
          "${pkgs.unison}/bin/unison"
          "orgs"
          "-repeat" "watch"
          "-auto" "-batch" "-prefer" "newer"
        ];
        RunAtLoad        = true;  # 登录后立刻跑
        KeepAlive        = true;  # 进程退出时自动重启
        WatchPaths       = [ onedriveOrg icloudOrg ];  # 依赖 watchPaths 再次触发
        StandardOutPath  = "/tmp/unison-launchd.out";
        StandardErrorPath= "/tmp/unison-launchd.err";
        EnvironmentVariables = {
          # 把 unison 和 unison-fsmonitor 的 bin 都加进来
          PATH = lib.concatStringsSep ":" [
            "${pkgs.unison}/bin"
            "${pkgs.unison-fsmonitor}/bin"
            "/usr/local/bin"  # 如果你平时还放了其他工具
            "/usr/bin"
            "/bin"
          ];
        };
      };
    };
  }
