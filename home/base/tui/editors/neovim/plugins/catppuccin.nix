{
  programs.nixvim.colorschemes.catppuccin = {
    enable = true;
    settings = {
      flavor = "mocha";
      integrations = {
        cmp = true;
        gitsigns = true;
        neotree = true;
        barbar = true;
        which_key = true;
        treesitter = true;
        fidget = true;
        notify = true;
        mini = {
          enabled = true;
          indentscope_color = "mauve";
        };
      };
    };
  };
}
