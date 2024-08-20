{mkKey, ...}: let
  inherit (mkKey) mkKeymap;
in {
  programs.nixvim = {
    plugins.comment = {
      enable = true;
    };
    keymaps = [
      (mkKeymap "n" "<leader>/" {__raw = ''function() require("Comment.api").toggle.linewise.current() end'';} "Toggle comment")
      (mkKeymap "v" "<leader>/" "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>" "Toggle comment")
    ];
  };
}
