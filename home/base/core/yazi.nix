{pkgs, ...}: {
  # terminal file manager
  programs.yazi = {
    enable = true;
    # Changing working directory when exiting Yazi
    enableBashIntegration = true;
    enableFishIntegration = true;
  };
}
