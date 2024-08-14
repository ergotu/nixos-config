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
  name = "k3s";
  tags = [name];
  ssh-user = "root";

  modules = {
    nixos-modules = map mylib.relativeToRoot [
      # common
      "modules/nixos/server"
      # host specific
      "hosts/${name}"
    ];
    home-modules = map mylib.relativeToRoot [
      "home/linux/tui.nix"
      "hosts/${name}/home.nix"
    ];
  };

  systemArgs = modules // args;
in {
  nixosConfigurations.${name} = mylib.nixosSystem systemArgs;

  colmena.${name} =
    mylib.colmenaSystem (systemArgs // {inherit tags ssh-user;});
}
