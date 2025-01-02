{...}: {
  programs.ghostty = {
    settings = {
      # MacOS settings
      window-title-font-family = "Fira Code Medium";
      macos-option-as-alt = true;
      macos-window-shadow = false;
      macos-auto-secure-input = true;
      macos-secure-input-indication = true;
    };
  };
}
