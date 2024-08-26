{
  lib,
  inputs,
  darwin-modules,
  home-modules ? [],
  system,
  genSpecialArgs,
  specialArgs ? (genSpecialArgs system),
  myvars,
  ...
}: let
  inherit (inputs) nixpkgs-darwin nix-darwin;
  home-manager = inputs.home-manager-darwin;
in
  nix-darwin.lib.darwinSystem {
    inherit system specialArgs;
    modules =
      darwin-modules
      ++ [
        ({lib, ...}: {
          nixpkgs.pkgs = import nixpkgs-darwin {inherit system;};
        })
      ]
      ++ (
        lib.optionals ((lib.lists.length home-modules) > 0)
        [
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.extraSpecialArgs = specialArgs;
            home-manager.users."${myvars.username}".imports = home-modules;

            home-manager.backupFileExtension = ".before-home-manager";
          }
        ]
      );
  }
