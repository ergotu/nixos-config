{
  # NOTE: the args not used in this file CAN NOT be removed!
  # because haumea pass argument lazily,
  # and these arguments are used in the functions like `mylib.nixosSystem`, `mylib.colmenaSystem`, etc.
  inputs,
  lib,
  mylib,
  myvars,
  system,
  genSpecialArgs,
  ...
} @ args: let
  name = "ergotu@bazzite";
in {
  # macOS's configuration
  homeConfigurations.${name} = {
    inherit system;
    extraSpecialArgs = genSpecialArgs system;

    modules = map mylib.relativeToRoot [
      "home/linux/tui.nix"
    ];
  };
}
