# outputs/aarch64-darwin/default.nix
{ lib, inputs, ... } @ args:
let
  inherit (inputs) haumea;

  data = haumea.lib.load { src = ./src; inputs = args; };
  dataWithoutPaths   = builtins.attrValues data;

  darwinConfigurations =
    lib.attrsets.mergeAttrsList
      (map (h: h.darwinConfigurations or h) dataWithoutPaths);

in
{
  inherit darwinConfigurations;

  evalTests = haumea.lib.loadEvalTests {
    src = ./tests;
    inputs = args // { inherit darwinConfigurations; };
  };

  inherit data;
}
