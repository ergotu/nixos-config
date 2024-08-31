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
  system = "x86_64-linux";

  inherit (inputs) nixpkgs home-manager;
  pkgs = nixpkgs.legacyPackages.${system};
in {
  # macOS's configuration
  homeConfigurations.${name} = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    modules = map mylib.relativeToRoot ["home/linux/tui.nix"];
    extraSpecialArgs = genSpecialArgs system;
  };
}
