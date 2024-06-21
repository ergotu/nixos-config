{
  lib,
  outputs,
}: let
  hostsNames = builtins.attrNames outputs.nixosConfigurations;
  expected = lib.genAttrs hostsNames (_: "aarch64-linux");
in
  expected
