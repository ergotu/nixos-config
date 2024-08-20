{
  opts,
  lib,
  ...
}: {
  programs.nixvim = {
    globals = {
      # Set the leader to space
      mapleader = " ";
      maplocalleader = " ";

      # Disable useless providers
      loaded_ruby_provider = 0; # Ruby
      loaded_perl_provider = 0; # Perl
      loaded_python_provider = 0; # Python 2

      floating_window_options = {
        border = "${opts.border}";
        winblend = 10;
      };
    };

    globalOpts.statusline = "%#Normal#";

    clipboard = {
      # Use system clipboard
      register = "unnamedplus";

      providers.wl-copy.enable = true;
    };

    opts = {
      pumblend = 0;
      pumheight = 10;

      expandtab = true;
      shiftwidth = 2;
      smartindent = true;
      tabstop = 2;
      softtabstop = 2;

      ignorecase = true;
      smartcase = true;
      mouse = "a";
      cmdheight = 0;

      number = true;
      relativenumber = true;
      numberwidth = 2;

      signcolumn = "yes";
      splitbelow = true;
      splitright = true;
      splitkeep = "screen";
      termguicolors = true;
      timeoutlen = lib.mkDefault 400;

      conceallevel = 2;

      undofile = true;

      wrap = false;

      virtualedit = "block";
      winminwidth = 5;
      fileencoding = "utf-8";
      list = true;
      fillchars = {eob = " ";};

      #interval for writing swap file to disk, also used by gitsigns
      updatetime = 100;
    };

    extraLuaPackages = ps: with ps; [luarocks];
    extraConfigLua = ''
      vim.opt.whichwrap:append("<>[]hl")
      vim.opt.listchars:append("space:·")
    '';
  };
}
