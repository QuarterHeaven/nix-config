{ inputs, pkgs, ... }:

{
  services.xremap = {
    serviceMode = "user";
    userName = "takaobsid";
    # enabled = true;
    withWlroots = true;
    # withHypr = true;
    yamlConfig = builtins.readFile "${inputs.dotfiles}/xremap-emacs.yaml";
    debug = false;
  };
}
