# just is a command runner, Justfile is very similar to Makefile, but simpler.

############################################################################
#
#  Common commands(suitable for all machines)
#
############################################################################

default:
  @just --list

# Remote deployment via colmena
col tag:
  nix-shell -p colmena nix --run "colmena apply --on '@{{tag}}' --verbose --show-trace"

col-remote tag:
  nix-shell -p colmena nix --run "colmena apply --on '@{{tag}}' --verbose --show-trace --build-on-target"

local name mode="default":
  use utils.nu *; \
  nixos-switch {{name}} {{mode}}

# Run eval tests
test:
  nix eval .#evalTests --show-trace --print-build-logs --verbose

# update all the flake inputs
up:
  nix flake update

# Update specific input
# Usage: just upp nixpkgs
upp input:
  nix flake update {{input}}

# List all generations of the system profile
history:
  nix profile history --profile /nix/var/nix/profiles/system

# Open a nix shell with the flake
repl:
  nix repl -f flake:nixpkgs --expr 'builtins.getFlake "."'

# remove all generations older than 7 days
clean:
  sudo nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d

# Garbage collect all unused nix store entries
gc:
  # garbage collect all unused nix store entries
  sudo nix-collect-garbage --delete-older-than 7d
  sudo nix-collect-garbage --delete-older-than 7d

# Remove all reflog entries and prune unreachable objects
gitgc:
  git reflog expire --expire-unreachable=now --all
  git gc --prune=now

############################################################################
#
#  Darwin related commands
#
############################################################################

[macos]
darwin-build:
  nom build ".#darwinConfigurations.jordi-mbp.system"

[macos]
darwin-switch:
  ./result/sw/bin/darwin-rebuild switch --flake ".#jordi-mbp"

[macos]
darwin-rollback:
  ./result/sw/bin/darwin-rebuild --rollback

############################################################################
#
#  Home Manager related commands
#
############################################################################

home-switch:
	home-manager switch --flake ".#$USER@$hostname"

############################################################################
#
#  Misc, other useful commands
#
############################################################################

format file:
  sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko {{file}}

fmt:
  # format the nix files in this repo
  alejandra fmt

path:
   $env.PATH | split row ":"

nvim-test:
  rm -rf $"($env.HOME)/.config/nvim"
  rsync -avz --copy-links --chmod=D2755,F744 home/base/tui/editors/neovim/nvim/ $"($env.HOME)/.config/nvim/"

nvim-clean:
  rm -rf $"($env.HOME)/.config/nvim"
