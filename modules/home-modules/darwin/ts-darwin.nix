{ pkgs, ... }:

{
  home.packages = with pkgs; [
    typescript-language-server
    vue-language-server
    vscode-langservers-extracted
  ];

  home.sessionPath = [ "$HOME/.ts" ];
  home.file = (builtins.listToAttrs [
    # {
    #   name = "ts/vue-typescript-plugin";
    #   value = { source = pkgs.vue-typescript-plugin; };
    # }
    {
      name = ".ts/typescript-language-server";
      value = { source = pkgs.typescript-language-server; };
    }
    {
      name = ".ts/vue-language-server";
      value = { source = pkgs.vue-language-server; };
    }
  ]);
}
