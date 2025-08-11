{ config, pkgs, lib, ... }:

{
  # 注意修改这里的用户名与用户目录
  home.username = "takaobsid";
  home.homeDirectory = "/home/takaobsid";

  # 直接将当前文件夹的配置文件，链接到 Home 目录下的指定位置
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # 递归将某个文件夹中的文件，链接到 Home 目录下的指定位置
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # 递归整个文件夹
  #   executable = true;  # 将其中所有文件添加「执行」权限
  # };

  # 直接以 text 的方式，在 nix 配置文件中硬编码文件内容
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # 设置鼠标指针大小以及字体 DPI（适用于 4K 显示器）
  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 172;
  };

  # git 相关配置
  programs.git = {
    enable = true;
    userName = "QuarterHeaven";
    userEmail = "liaotx2@gmail.com";
    extraConfig = {
      github.user = "QuarterHeaven";
      credential.helper = "keepassxc --git-groups";
      core.autocrlf = false;
    };
  };

  # 通过 home.packages 安装一些常用的软件
  # 这些软件将仅在当前用户下可用，不会影响系统级别的配置
  # 建议将所有 GUI 软件，以及与 OS 关系不大的 CLI 软件，都通过 home.packages 安装
  home.packages = with pkgs; [
    onefetch
    screenfetch
    ncdu
    gparted

    # archives
    zip
    xz
    unzip
    p7zip

    # utils
    ripgrep # recursively searches directories for a regex pattern
    yq-go # yaml processer https://github.com/mikefarah/yq
    eza # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder
    fd # alternative of find
    coreutils-prefixed
    xclip
    maestral
    maestral-gui # Dropbox 3rd party client
    ffmpeg
    sops

    # networking tools
    mtr # A network diagnostic tool
    iperf3
    dnsutils # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide the command `drill`
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing
    ipcalc # it is a calculator for the IPv4/v6 addresses

    # misc
    cowsay
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    btop # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring

    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

    # system tools
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb

    librime
    rime-data

    # Dropbox third-party client
    # maestral
    # maestral-gui
    # use https://codeberg.org/akiross/podman-dropbox instead

    # Language settings
    rustup
    typst
    # typst-lsp
    typstfmt
    typst-live
    texliveFull

    xapian
    nil # nix lsp
  ];

  # 启用 starship，这是一个漂亮的 shell 提示符
  programs.starship = { enable = true; };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      starship init fish | source
    '';
    shellAliases = {
      ls =
        "eza --git --git-repos --icons=always --hyperlink --color=always --color-scale=all --color-scale-mode=gradient";
      l =
        "eza --git --git-repos --icons=always --hyperlink --color=always --color-scale=all --color-scale-mode=gradient";
      la =
        "eza --git --git-repos --icons=always --hyperlink --color=always --color-scale=all --color-scale-mode=gradient -la";
      gcc = "clang";
      "g++" = "clang++";
      open = "handlr open";
    };
  };

  programs.nushell = { enable = true;
      # The config.nu can be anywhere you want if you like to edit your Nushell with Nu
      # configFile.source = ./.../config.nu;
      # for editing directly to config.nu 
      extraConfig = ''
       let carapace_completer = {|spans|
       carapace $spans.0 nushell ...$spans | from json
       }
       $env.config = {
        show_banner: false,
        completions: {
        case_sensitive: false # case-sensitive completions
        quick: true    # set to false to prevent auto-selecting completions
        partial: true    # set to false to prevent partial filling of the prompt
        algorithm: "fuzzy"    # prefix or fuzzy
        external: {
        # set to false to prevent nushell looking into $env.PATH to find more suggestions
            enable: true 
        # set to lower can improve completion performance at the cost of omitting some options
            max_results: 100 
            completer: $carapace_completer # check 'carapace_completer' 
          }
        }
       } 
       $env.PATH = ($env.PATH | 
       split row (char esep) |
       prepend /Users/takaobsid/.apps |
       prepend /home/takaobsid/.apps |
       append /usr/bin/env |
       append /usr/local/bin
       )
       mkdir ($nu.data-dir | path join "vendor/autoload")
       starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
       '';
       shellAliases = {
       vi = "hx";
       vim = "hx";
       nano = "hx";
       };
   };  
   programs.carapace.enable = true;
   programs.carapace.enableNushellIntegration = true;
  
  programs.bash = {
    enable = true;
    shellAliases = {
      gcc = "clang";
      "g++" = "clang++";
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.bat = { enable = true; };

  programs.htop = { enable = true; };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
