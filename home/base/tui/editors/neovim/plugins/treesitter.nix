{pkgs, ...}: {
  programs.nixvim.plugins = {
    treesitter = {
      enable = true;

      nixvimInjections = true;

      folding = true;
      indent = true;
    };

    treesitter-textobjects = {enable = true;};
    mini.enable = true;
    indent-blankline = {
      enable = true;
      settings = {
        exclude = {
          filetypes = [
            "dashboard"
            "lspinfo"
            "packer"
            "checkhealth"
            "help"
            "man"
            "gitcommit"
            "TelescopePrompt"
            "TelescopeResults"
            "''"
          ];
        };
      };
    };
    treesitter-refactor = {
      enable = true;
      highlightDefinitions = {
        enable = true;
        # Set to false if you have an `updatetime` of ~100.
        clearOnCursorMove = false;
      };
    };
    hmts.enable = true;
  };
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [nvim-treesitter-textsubjects];
    extraConfigLua = ''
      require('mini.indentscope').setup({
        symbol = "╎",
      })

      require("nvim-treesitter.configs").setup({
        textsubjects = {
          enable = true,
          prev_selection = ",", -- (Optional) keymap to select the previous prev_selection
          keymaps = {
            ["."] = "textsubject-smart",
            [";"] = "textsubjects-container-outer",
            ["i;"] = { "textsubjects-container-inner", desc = "Select inside containers (classes, functions, etc.)"},
          },
        },
      })
    '';
  };
}
