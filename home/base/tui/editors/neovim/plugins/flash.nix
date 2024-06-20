{mkKey, ...}: let
  inherit (mkKey) mkKeymap;
in {
  programs.nixvim = {
    plugins.flash = {
      enable = true;

      search = {
        mode = "fuzzy";
      };

      jump = {
        autojump = true;
      };

      label = {
        uppercase = false;
        rainbow = {
          enabled = false;
          shade = 5;
        };
      };
    };

    keymaps = [
      (mkKeymap "n" "s" "<cmd>lua require('flash').jump()<cr>" "Flash")
      (mkKeymap "n" "S" "<cmd>lua require('flash').treesitter()<cr>" "Flash Treesitter")

      (mkKeymap "x" "s" "<cmd>lua require('flash').jump()<cr>" "Flash")
      (mkKeymap "x" "S" "<cmd>lua require('flash').treesitter()<cr>" "Flash Treesitter")
      (mkKeymap "x" "R" "<cmd>lua require('flash').treesitter_search()<cr>" "Flash Treesitter Search")

      (mkKeymap "o" "s" "<cmd>lua require('flash').jump()<cr>" "Flash")
      (mkKeymap "o" "S" "<cmd>lua require('flash').treesitter()<cr>" "Flash Treesitter")
      (mkKeymap "o" "r" "<cmd>lua require('flash').remote()<cr>" "Flash Remote")
      (mkKeymap "o" "R" "<cmd>lua require('flash').treesitter_search()<cr>" "Flash Treesitter Search")
    ];
  };
}
