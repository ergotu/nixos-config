{
  self,
  nixpkgs,
  pre-commit-hooks,
  nvimdots,
  ...
} @ inputs: let
  inherit (inputs.nixpkgs) lib;
  mylib = import ../lib {inherit lib;};
  myvars = import ../vars {inherit lib;};

  opts = {
    border = "rounded";
    transparent = "true";
  };

  # Add my custom lib, vars, nixpkgs instance, and all the inputs to specialArgs,
  # so that I can use them in all my nixos/home-manager/darwin modules.
  genSpecialArgs = system:
    inputs
    // {
      inherit mylib myvars;
      inherit (mylib) mkKey;

      inherit opts;

      # use unstable branch for some packages to get the latest updates
      pkgs-unstable = import inputs.nixpkgs-unstable {
        inherit
          system
          ; # refer the `system` parameter form outer scope recursively
        # To use chrome, we need to allow the installation of non-free software
        config.allowUnfree = true;
      };

      inherit inputs;

      pkgs-stable = import inputs.nixpkgs-stable {
        inherit system;
        # To use chrome, we need to allow the installation of non-free software
        config.allowUnfree = true;
      };

      secrets =
        builtins.fromJSON (builtins.readFile "${self}/secrets/secrets.json");
    };

  # This is the args for all the haumea modules in this folder.
  args = {inherit inputs lib mylib myvars genSpecialArgs;};

  # modules for each supported system
  nixosSystems = {
    x86_64-linux = import ./x86_64-linux (args // {system = "x86_64-linux";});
    aarch64-linux =
      import ./aarch64-linux (args // {system = "aarch64-linux";});
  };
  darwinSystems = {
    aarch64-darwin =
      import ./aarch64-darwin (args // {system = "aarch64-darwin";});
  };
  allSystems = nixosSystems // darwinSystems;
  allSystemNames = builtins.attrNames allSystems;
  nixosSystemValues = builtins.attrValues nixosSystems;
  darwinSystemValues = builtins.attrValues darwinSystems;
  allSystemValues = nixosSystemValues ++ darwinSystemValues;

  # Helper function to generate a set of attributes for each system
  forAllSystems = func: (nixpkgs.lib.genAttrs allSystemNames func);

  homeSystems = import ./homemanager args;
in {
  # Add attribute sets into outputs, for debugging
  debugAttrs = {
    inherit nixosSystems darwinSystems allSystems allSystemNames homeSystems;
  };

  homeConfigurations = homeSystems.homeConfigurations;

  # NixOS Hosts
  nixosConfigurations =
    lib.attrsets.mergeAttrsList
    (map (it: it.nixosConfigurations or {}) nixosSystemValues);

  # Colmena - remote deployment via SSH
  colmena =
    {
      meta =
        (let
          system = "x86_64-linux";
        in {
          # colmena's default nixpkgs & specialArgs
          nixpkgs = import nixpkgs {inherit system;};
          specialArgs = genSpecialArgs system;
        })
        // {
          # per-node nixpkgs & specialArgs
          nodeNixpkgs =
            lib.attrsets.mergeAttrsList
            (map (it: it.colmenaMeta.nodeNixpkgs or {}) nixosSystemValues);
          nodeSpecialArgs =
            lib.attrsets.mergeAttrsList
            (map (it: it.colmenaMeta.nodeSpecialArgs or {}) nixosSystemValues);
        };
    }
    // lib.attrsets.mergeAttrsList
    (map (it: it.colmena or {}) nixosSystemValues);

  # macOS Hosts
  darwinConfigurations =
    lib.attrsets.mergeAttrsList
    (map (it: it.darwinConfigurations or {}) darwinSystemValues);

  # Packages
  packages = forAllSystems (system: allSystems.${system}.packages or {});

  # Eval Tests for all NixOS & darwin systems.
  evalTests = lib.lists.all (it: it.evalTests == {}) allSystemValues;

  checks = forAllSystems (system: let
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    # eval-tests per system
    # eval-tests = allSystems.${system}.evalTests == {};

    pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
      src = ./.;
      default_stages = ["pre-commit"];
      hooks = {
        commitizen.enable = true;
        check-added-large-files.enable = true;
        check-case-conflicts.enable = true;
        check-executables-have-shebangs.enable = true;
        check-shebang-scripts-are-executable.enable = true;
        check-merge-conflicts.enable = true;
        detect-private-keys.enable = true;
        fix-byte-order-marker.enable = true;
        mixed-line-endings.enable = true;
        trim-trailing-whitespace.enable = true;

        forbid-submodules = {
          enable = true;
          name = "forbid submodules";
          description = "forbids any submodules in the repository";
          language = "fail";
          entry = "submodules are not allowed in this repository:";
          types = ["directory"];
        };

        destroyed-symlinks = {
          enable = true;
          name = "destroyed-symlinks";
          description = "detects symlinks which are changed to regular files with a content of a path which that symlink was pointing to.";
          package = inputs.pre-commit-hooks.checks.${system}.pre-commit-hooks;
          entry = "${
            inputs.pre-commit-hooks.checks.${system}.pre-commit-hooks
          }/bin/destroyed-symlinks";
          types = ["symlink"];
        };

        alejandra.enable = true;
        shfmt.enable = true;

        end-of-file-fixer.enable = true;
      };
    };
  });

  # Development Shells
  devShells = forAllSystems (system: let
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    default = pkgs.mkShell {
      packages = with pkgs; [
        # fix https://discourse.nixos.org/t/non-interactive-bash-errors-from-flake-nix-mkshell/33310
        bashInteractive
        # fix `cc` replaced by clang, which causes nvim-treesitter compilation error
        gcc
        # Nix-related
        alejandra
        deadnix
        statix
        # spell checker
        typos
        # code formatter
        nodePackages.prettier

        nvimdots.packages.${system}.neovim
      ];
      name = "dots";
      shellHook = ''
        ${self.checks.${system}.pre-commit-check.shellHook}
      '';
    };
  });

  # Format the nix code in this flake
  formatter = forAllSystems (
    # alejandra is a nix formatter with a beautiful output
    system: nixpkgs.legacyPackages.${system}.alejandra
  );
}
