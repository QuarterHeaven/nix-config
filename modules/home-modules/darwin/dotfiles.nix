{ inputs, pkgs, ... }:

let
  sbLuaPackage = inputs.sbar_lua.packages.aarch64-darwin.sketchybar-lua;
  # cjsonSo = pkgs.lua54Packages.lua-cjson + "/lib/lua/5.4/cjson.so";
  # luaPosixSo = pkgs.lua54Packages.luaposix;

  # mergedSketchybarLua = pkgs.runCommandLocal "merged-sketchybar-lua" {} ''
  #   mkdir -p $out
  #   cp -r ${sbLuaPackage}/share/sketchybar_lua/* $out/
  #   cp ${cjsonSo} $out/cjson.so
  #   cp -r ${luaPosixSo}/lib/lua/5.4/* $out/
  # '';
  in
  {
    home.file = {
      ".unison/orgs.prf".source = "${inputs.dotfiles}/unison/orgs.prf";
      # ".local/share/sketchybar_lua".source = mergedSketchybarLua;
      # ".local/share/luaposix".source = "${luaPosixSo}/share/lua/5.4/posix";
    };
  }
