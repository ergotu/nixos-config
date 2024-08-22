{pkgs, ...}: {
  programs = {
    neovim = {
      enable = true;

      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      nvimdots = {
        enable = true;

        withBuildTools = true; # Only needed for NixOS
      };
    };
  };
}
