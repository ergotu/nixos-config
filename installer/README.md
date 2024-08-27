# NixOS setup for host: k3s-master-0

This is how to deploy the config for k3s-master-0 on a new machine This configuration has it's disk
partitioning declared with [disko](https://github.com/nix-community/disko)

After booting the NixOS minimal ISO run the following commands

```bash
# Set up a nix-shell with the required software
nix-shell -p git

# Pull in the flake
git clone https://github.com/ergotu/nixos-config

# Partition the disks using disko
cd nixos-config
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko hosts/k3s-master-0/disko-config.nix

# Install the flake
sudo nixos-install --root /mnt --flake .#k3s-master-0

# Reboot the machine
sudo reboot now

```
