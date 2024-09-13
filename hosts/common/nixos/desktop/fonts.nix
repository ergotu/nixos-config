{pkgs, ...}: {
  fonts = {
    enableDefaultPackages = false;
    fontDir.enable = true;

    packages = with pkgs; [
      # icon fonts
      material-design-icons
      font-awesome
      noto-fonts-emoji

      fira-code
      iosevka
      monaspace
      jetbrains-mono

      source-sans
      source-serif

      (nerdfonts.override {
        fonts = [
          # symbols only
          "NerdFontsSymbolsOnly"

          # characters
          "FiraCode"
          "Iosevka"
          "Monaspace"
          "JetBrainsMono"
        ];
      })
    ];
    fontconfig.defaultFonts = {
      serif = ["Source Serif SC" "Noto Color Emoji"];
      sansSerif = ["Source Sans SC" "Noto Color Emoji"];
      monospace = ["Fira Code Mono" "Noto Color Emoji"];
      emoji = ["Noto Color Emoji"];
    };
  };

  services.kmscon = {
    enable = true;
    fonts = [
      {
        name = "Source Code Pro";
        package = pkgs.source-code-pro;
      }
    ];
    extraOptions = "--term xterm-256color";
    extraConfig = "font-size=14";
    hwRender = true;
  };
}
