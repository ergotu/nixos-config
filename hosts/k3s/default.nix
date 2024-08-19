{
  disko,
  pkgs,
  mylib,
  myvars,
  ...
}: let
  hostName = "k3s";

  k3sModule = mylib.genK3sStandaloneModule {
    inherit pkgs;
    kubeconfigFile = "/home/${myvars.username}/.kube/config";
    masterHost = "k3s.in.ergotu.com";
  };
in {
  imports = [
    # Include results of the hardware scan.
    ./hardware-configuration.nix
    disko.nixosModules.default
    ./disko-config.nix
    k3sModule
  ];

  boot.loader = {
    grub = {
      enable = true;
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

  services.qemuGuest.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
