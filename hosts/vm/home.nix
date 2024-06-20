{
  lib,
  catppuccin,
  ...
}: {
  imports = [
    catppuccin.homeManagerModules.catppuccin
  ];

  catppuccin = {
    enable = true;
    flavor = "mocha";
  };

  custom.cloud.enabled = false;
}
