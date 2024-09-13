{
  configLib,
  lib,
  ...
}: {
  imports = configLib.scanPaths ./.;

  custom.cloud.enabled = lib.mkDefault false;
}
