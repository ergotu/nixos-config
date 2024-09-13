{
  configLib,
  configVars,
  ...
}: {
  home.homeDirectory = "/Users/${configVars.username}";
  imports =
    (configLib.scanPaths ./.)
    ++ [
      ../base/core
      ../base/tui
      ../base/gui
      ../base/home.nix
    ];
}
