{ pkgs, ... }:

{
  home.sessionVariables = {
    # PATH = "/opt/homebrew/bin:$PATH:$HOME/bin:$HOME/.local/share/applications:/Applications/Emacs.app/Contents/MacOS/bin:/Applications/Emacs.app/Contents/MacOS:$HOME/.npm-packages/bin/";
    MAVEN_PATH = "${pkgs.maven}/maven";
    # JAVA_HOME = "${pkgs.jdk8}/zulu-8.jdk/Contents/Home";
    LDFLAGS = "-L/usr/local/opt/openssl@3/lib";
    CPPFLAGS = "-I/usr/local/opt/openssl@3/include";
    PKG_CONFIG_PATH = builtins.concatStringsSep ":" [
      "${pkgs.zlib.dev}/lib/pkgconfig"
      "/usr/local/opt/openssl@3/lib/pkgconfig"
      "$PKG_CONFIG_PATH"  # 保留系统原有路径
    ];
  };
}
