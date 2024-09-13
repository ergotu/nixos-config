{
  lib,
  inputs,
  darwin-modules,
  home-modules ? [],
  system,
  genSpecialArgs,
  specialArgs ? (genSpecialArgs system),
  configVars,
  ...
}: let
  inherit (inputs) nixpkgs-darwin nix-darwin;
  home-manager = inputs.home-manager-stable;
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
            home-manager.users."${configVars.username}".imports = home-modules;

            home-manager.backupFileExtension = ".before-home-manager";
          }
        ]
      );
  }
