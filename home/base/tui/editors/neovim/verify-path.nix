let
  nvimPath = builtins.path {path = ./nvim;};
in {
  inherit nvimPath;
}
