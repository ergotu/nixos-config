{
  ghostty-hm,
  ghostty,
  pkgs,
  ...
}: {
  imports = [ghostty-hm.homeModules.default];

  programs.ghostty = {
    enable = true;

    settings = {
      # Font Config
      font-size =
        if pkgs.stdenv.isDarwin
        then 15
        else 13;
      font-family = "Fira Code Regular";
      font-family-italic = "Iosevka Italic";
      font-family-bold-italic = "Iosevka Bold Italic";
      font-feature = ["zero"];

      # Char Rendering
      adjust-cell-width = "-5%";
      adjust-underline-position = 6;
      adjust-underline-thickness = "40%";
      adjust-cursor-thickness = "150%";

      # Colours
      theme = "dark:catppuccin-mocha,light:catppuccin-frappe";
      unfocused-split-opacity = 0.96;

      # Cursor
      cursor-color = "F8F8F2";
      cursor-style-blink = false;

      # Closing
      confirm-close-surface = false;
      quit-after-last-window-closed = true;
    };
    keybindings = {
      "alt+one" = "goto_tab:1";
      "alt+two" = "goto_tab:2";
      "alt+three" = "goto_tab:3";
      "alt+four" = "goto_tab:4";
      "alt+five" = "goto_tab:5";
      "alt+shift+t" = "new_tab";
      "alt+shift+comma" = "reload_config";
      "alt+shift+q" = "close_surface";
      "alt+shift+i" = "inspector:toggle";
      "alt+equal" = "increase_font_size:1";
      "alt+minus" = "decrease_font_size:1";
      "alt+zero" = "reset_font_size";
      "alt+shift+v" = "new_split:right";
      "alt+shift+s" = "new_split:down";
      "alt+shift+j" = "goto_split:bottom";
      "alt+shift+k" = "goto_split:top";
      "alt+shift+h" = "goto_split:left";
      "alt+shift+l" = "goto_split:right";
      "alt+shift+enter" = "toggle_fullscreen";
    };
  };
}
