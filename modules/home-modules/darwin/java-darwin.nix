{ pkgs, ... }:

let
  additional_jdks = with pkgs; [
    jdk8
    jdk17
    jdk21
  ];
  in
{
  home.packages = with pkgs; [
    maven
    jdt-language-server
    lombok
    vscode-extensions.vscjava.vscode-java-debug
    vscode-extensions.vscjava.vscode-java-test
  ];

  home.sessionPath = [ "$HOME/.jdks" ];
  home.file = (builtins.listToAttrs (builtins.map (jdk: {
    name = ".jdks/${jdk.version}";
    value = { source = jdk; };
  }) additional_jdks ++ [
    {
      name = ".jdks/jdtls";
      value = { source = pkgs.jdt-language-server; };
    }
    {
      name = ".jdks/clj-lsp";
      value = { source = pkgs.clojure-lsp;};
    }
    {
      name = ".jdks/lombok";
      value = { source = pkgs.lombok; };
    }
    {
      name = ".jdks/java-debug";
      value = { source = pkgs.vscode-extensions.vscjava.vscode-java-debug; };
    }
    {
      name = ".jdks/java-test";
      value = { source = pkgs.vscode-extensions.vscjava.vscode-java-test; };
    }
    {
      name = ".jdks/mvn";
      value = { source = pkgs.maven; };
    }
  ]));
  home.sessionVariables.JAVA_HOME = "${pkgs.jdk17}/lib/openjdk";
}
