{
  mylib,
  lib,
  ...
}: {
  imports = mylib.scanPaths ./.;

  custom.cloud.enabled = lib.mkDefault true;
}
