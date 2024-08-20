{nixvim, ...}: {
  imports = [nixvim.homeManagerModules.nixvim];

  home.shellAliases.vc = "nvim";

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    viAlias = true;
    vimAlias = true;

    luaLoader.enable = true;
  };
}
