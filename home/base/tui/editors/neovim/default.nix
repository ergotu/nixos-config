{nvimdots, ...}: let
  shellAliases = {
    v = "nvim";
    vdiff = "nvim -d";
  };
in {
  imports = [
    nvimdots.homeManagerModules.nvimdots
  ];

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
