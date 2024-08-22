{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}: let
  shellAliases = {
    v = "nvim";
    vdiff = "nvim -d";
  };
in {
  home.shellAliases = shellAliases;

  programs.neovim = {
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    nvimdots = {
      enable = true;
      withBuildTools = true; # Only needed for NixOS
    };
  };
}
