{pkgs, ...}: {
  programs = {
    neovim = {
      enable = true;

      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      nvimdots = {
        enable = true;

        setBuildEnv = true; # Only needed for NixOS
        withBuildTools = true; # Only needed for NixOS
      };
    };
  };
}
