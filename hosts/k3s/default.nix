{
  catppuccin,
  disko,
  pkgs,
  lib,
  ...
}: let
  hostName = "k3s";
in {
  imports = [
    # Include results of the hardware scan.
    ./hardware-configuration.nix
    catppuccin.nixosModules.catppuccin
    disko.nixosModules.default
    ./disko-config.nix
  ];

  catppuccin = {
    enable = true;
    flavor = "mocha";
  };

  boot.loader = {
    grub = {
      enable = lib.mkForce true;
      efiSupport = true;
      useOSProber = true;
      efiInstallAsRemovable = true;
    };
    systemd-boot = {
      enable = false;
    };
  };

  networking = {
    inherit hostName;
  };

  environment.systemPackages = with pkgs; [
    k3s_1_29
    k9s
    kubectl
    istioctl
    kubernetes-helm
    cilium-cli
    fluxcd
    skopeo
    dive
  ];

  services.k3s = {
    enable = true;
    package = pkgs.k3s_1_29;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
