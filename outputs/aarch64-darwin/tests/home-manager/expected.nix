{
  myvars,
  lib,
}: let
  username = myvars.username;
  hosts = [
    "jordi-mbp"
  ];
in
  lib.genAttrs hosts (_: "/Users/${username}")
