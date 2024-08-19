{lib, ...}: {
  colmenaSystem = import ./colmenaSystem.nix;
  macosSystem = import ./macosSystem.nix;
  nixosSystem = import ./nixosSystem.nix;

  attrs = import ./attrs.nix {inherit lib;};

  genK3sServerModule = import ./genK3sServerModule.nix;
  genK3sAgentModule = import ./genK3sAgentModule.nix;
  genK3sStandaloneModule = import ./genK3sStandaloneModule.nix;

  icons = import ./icons.nix;

  mkKey = rec {
    mkKeymap = mode: key: action: desc: {
      inherit mode key action;
      options = {
        inherit desc;
        silent = true;
        noremap = true;
      };
    };
    mkKeymap' = mode: key: action:
      mkKeymap mode key action null;

    mkKeymapWithOpts = mode: key: action: desc: opts:
      (mkKeymap mode key action desc) // {options = opts;};
  };
  # use path relative to the root of the project
  relativeToRoot = lib.path.append ../.;
  scanPaths = path:
    builtins.map
    (f: (path + "/${f}"))
    (builtins.attrNames
      (lib.attrsets.filterAttrs
        (
          path: _type:
            (_type == "directory") # include directories
            || (
              (path != "default.nix") # ignore default.nix
              && (lib.strings.hasSuffix ".nix" path) # include .nix files
            )
        )
        (builtins.readDir path)));
}
