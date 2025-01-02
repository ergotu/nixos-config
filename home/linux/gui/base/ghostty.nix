{
  ghostty,
  pkgs,
  ...
}: {
  programs.ghostty = {
    package = ghostty.packages.${pkgs.system}.default;
    settings = {
      # Linux Settings
      window-theme = "ghostty";
      gtk-adwaita = false;
      gtk-titlebar = false;
    };
  };
}
