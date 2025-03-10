{ pkgs, ... }:

let
  additional_jdks = with pkgs; [
    jdk8
    jdk17
    jdk21
  ];
  in
{
  users.users.takaobsid.packages = with pkgs; [
    maven
    # jdk8
    # jdk17
    # jdk21
    jdt-language-server
    lombok
  ];

  environment.variables.JAVA_8_HOME = "${pkgs.jdk8}/lib/openjdk";
  environment.variables.JAVA_17_HOME = "${pkgs.jdk17}/lib/openjdk";
  environment.variables.JAVA_21_HOME = "${pkgs.jdk21}/lib/openjdk";  
}
