{ pkgs, ... } @ attrs: let
  jbr = import ./jbr/default.nix attrs;
  in

{
  users.users.takaobsid.packages = with pkgs; [
    jetbrains.idea-ultimate
    vscode
    maven
    google-chrome
    jdk8
    jdk17
    unstable.jetbrains.jdk

    (callPackage ./jbr/default.nix {})

    jdt-language-server
    lombok
  ];

  programs.java = {
    enable = true;
    # package = pkgs.jdk17;
    package = pkgs.jetbrains.jdk;
    # package = (pkgs.callPackage ./jbr/default.nix {});
  };

  environment.variables.IDEA_JDK = "${jbr}";
  environment.variables.IDEA_VM_OPTIONS = "-Dawt.toolkit.name=WLToolkit";
  environment.variables.JAVA_8_HOME = "${pkgs.jdk8}/lib/openjdk";
  environment.variables.JAVA_17_HOME = "${pkgs.jdk17}/lib/openjdk";
}
