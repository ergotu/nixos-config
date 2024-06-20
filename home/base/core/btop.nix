{pkgs, ...}: {
  # replacement of htop/nmon
  programs.btop = {
    enable = true;
  };
}
