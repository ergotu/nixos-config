## 0.2.0 (2024-12-06)

### Feat

- **flake**: update to 24.11

## 0.1.0 (2024-12-05)

### Feat

- enable the linux builder for darwin devices
- add nixos-hardware modules for desktop configuration
- **klipper**: enable lanzaboote
- **klipper**: switch to systemd-boot
- add hardening features for nixos systems
- **darwin**: migrate to aerospace
- add mockoon to gui dev-tools
- add monaspace font
- add font config for desktop machines
- add pterodactyl host configuration
- move klipper stuff to it's own user
- add klipperscren
- add extra tools to dev-tools
- add klipper config
- add github runner vm configuration
- add desktop host
- add initial hyprland configuration
- move darwin home manager to the stable channel
- add sunshine server for desktop clients
- add tailscale to all nixos hosts
- add hardware-configuration for kubevirt guests
- add aarch64 server configuration
- add just commands
- move initialHashedPassword to vars file
- upgrade to k3s 1.30
- add option to justfile to build on target machine
- add vaults to impermanence config
- add the possibility to define homeConfigurations
- change trusted public key in workflow
- add inital sops file
- add sops-nix input
- add disko format command to justfile
- add default trusted caches
- add workflow that builds systems and pushes them to cache
- add attic-client to base module for binary cache management
- add arc browser brew cask for darwin
- add k8s tag for colmena deployments
- move nix-melt to stable nixpkgs
- add additional persisted paths
- add binary cache for nix-community projects
- remove unused icons config
- change formatter
- set up nvimdots to follow nixpkgs
- **nvim**: disable nvimdots in core
- **nvim**: add custom lua based nvim installation

### Fix

- set nixPath for darwin
- add system.stateVersion for darwin host
- move nix path config to nixos specific folder
- nix path
- add custom flashing script
- change paths in impermanence
- move github-runner to core home-manager
- fix the attic cache key
- fix the cleanup script for root
- fix configuration for the github actions runner
- add netdata for aarch64 servers

### Refactor

- change the klipper config layout
- change home manager configuration for standalone hosts
- move nvimdots import so it doesnt happen on every system
