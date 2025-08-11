{ config, inputs, pkgs, ... }:

let
  sbLuaPackage = inputs.sbar_lua.packages.aarch64-darwin.sketchybar-lua;

  luaEnv = pkgs.lua5_3.withPackages (ps: with ps; [
    lua-cjson
    luaposix
  ]);
  
  in
  {
    environment.systemPackages = with pkgs; [
      sketchybar
      sbLuaPackage
      lua54Packages.lua
      # lua53Packages.lua-cjson
      # lua53Packages.luaposix
    ];

    services.sketchybar = {
      # enable =true;
      enable = false;
    };
  }
