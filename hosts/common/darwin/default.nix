{configLib, ...}: {
  imports =
    (configLib.scanPaths ./.)
    ++ [
      ../base.nix
    ];
}
