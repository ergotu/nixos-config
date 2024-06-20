{
  myvars,
  lib,
}: let
  username = myvars.username;
  hosts = [
    "vm"
  ];
in
  lib.genAttrs hosts (_: "/home/${username}")
