{
  lib,
  pkgs,
  pkgs-unstable,
  ...
}: {
  #############################################################
  #
  #  Basic settings for development environment
  #
  #  Please avoid to install language specific packages here(globally),
  #  instead, install them:
  #     1. per IDE, such as `programs.neovim.extraPackages`
  #     2. per-project, using https://github.com/the-nix-way/dev-templates
  #
  #############################################################

  home.packages = with pkgs; [
    colmena # nixos's remote deployment tool
  ];

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;

      #enableFishIntegration = true;
      enableBashIntegration = true;
    };
  };
}
