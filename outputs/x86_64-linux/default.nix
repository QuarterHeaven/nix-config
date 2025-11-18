# outputs/x86_64-linux/default.nix
{ lib, inputs, ... } @ args:
let
  inherit (inputs) haumea;

  data = haumea.lib.load { src = ./src; inputs = args; };
  dataWithoutPaths   = builtins.attrValues data;

  nixosConfigurations =
    lib.attrsets.mergeAttrsList
      (map (h: h.nixosConfigurations or h) dataWithoutPaths);

in
{
  inherit nixosConfigurations;

  evalTests = haumea.lib.loadEvalTests {
    src = ./tests;
    inputs = args // { inherit nixosConfigurations; };
  };

  inherit data;
}
