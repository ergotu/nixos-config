{pkgs, ...}: {
  home.packages = with pkgs; [
    gamescope # SteamOS session compositing window manager
    winetricks # A script to install DLLs needed to work around problems in Wine
  ];
}
