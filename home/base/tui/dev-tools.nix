{pkgs, ...}: {
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

    # Automatically trims your branches whose tracking remote refs are merged or gone
    # It's really useful when you work on a project for a long time.
    git-trim
    gitleaks

    # misc
    bfg-repo-cleaner # remove large files from git history
    k6 # load testing tool
    protobuf # protocol buffer compiler

    # solve coding extercises - learn by doing
    exercism
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
