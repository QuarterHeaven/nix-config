{
  description = "Flake to build SbarLua (Lua API for SketchyBar)";

  inputs = {
    # 使用 unstable 通道
    nixpkgs.url     = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    # 本地 path 引用 SbarLua 目录
    sbarlua = { url = "github:FelixKratz/SbarLua"; flake = false; };
  };

  outputs = { self, nixpkgs, flake-utils, sbarlua, ... }:
    flake-utils.lib.eachSystem [ "x86_64-darwin" "aarch64-darwin" ] (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        in {
          packages = {
            sketchybar-lua = pkgs.stdenv.mkDerivation {
              pname            = "sketchybar-lua";
              version          = "unstable";
              src              = sbarlua;

              nativeBuildInputs = [ pkgs.clang pkgs.gnumake pkgs.gnused pkgs.readline ];

              patchPhase = ''

            sed -i "s|^INSTALL_DIR.*|INSTALL_DIR = $out/share/sketchybar_lua|" makefile
            
    sed -i \
    -e "s|CC= gcc -std=gnu99 -arch arm64|CC = ${pkgs.clang}/bin/clang -std=gnu99 -arch arm64|" \
    -e "s|CC= gcc -std=gnu99 -arch x86_64|CC = ${pkgs.clang}/bin/clang -std=gnu99 -arch x86_64|" \
    lua-5.4.7/src/Makefile
              '';

              # 官方 Makefile: CC override + install
              buildPhase = ''
                export CC=${pkgs.clang}/bin/clang
              export CFLAGS="-std=c99 -O3 -g -shared -fPIC"
              export INSTALL_DIR=$out/share/sketchybar_lua
              make install
              '';

              installPhase = ''
                # nothing else
              '';

              meta = with pkgs.lib; {
                description = "Lua API module for SketchyBar, enabling IPC from Lua";
                homepage    = "https://github.com/FelixKratz/SbarLua";
                license     = licenses.gpl3;
                maintainers = [];
              };
            };
          };

          # default package for `nix build`
          defaultPackage = pkgs.sketchybar-lua;
        }
    );
}
