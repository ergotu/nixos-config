{
  mylib,
  myvars,
  ...
}: {
  home.homeDirectory = "/Users/${myvars.username}";
  imports =
    (mylib.scanPaths ./.)
    ++ [
      ../base/core
      ../base/tui
      # ../base/gui
      ../base/home.nix
    ];
}
