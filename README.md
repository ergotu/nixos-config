# My Nix config for both NixOS and nix-darwin devices

This repo is home to the nix code that builds my systems:

- NixOS based desktops, with home-manager and hyprland
- Mac devices with nix-darwin and home manager, sharing the same configuration with NixOS based
  devices
- NixOS based servers that run various services
- Home-manager configurations for other systems

Details of the hosts is stored in [./hosts](https://github.com/ergotu/nixos-config/blob/main/hosts)

## Neovim

See [ergotu/neovim](https://github.com/ergotu/neovim) for more details.

## Deploying this flake

> **_IMPORTANT_**: **Do NOT deploy this flake directly onto your machine, it will not work** This
> flake contains my hardware configurations, which will likely not match with your own needs

For NixOS based systems:

> To deploy this flake from NixOS' official ISO: [./installer](./installer/README.md)

```bash
# Using nixos-rebuild
sudo nixos-rebuild switch --flake .#k3s-master-0

```

For nix-darwin based systems:

```bash
# If deploying for the first time
# 1 Install nix and homebrew manually
# 2 Start a nix-shell with the necessary packages
nix-shell -p just

# 3 Build the macos configuration
just darwin-build

# 4 Deploy the macos configuration
just macos-switch

```
