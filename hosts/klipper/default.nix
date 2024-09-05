{
  disko,
  secrets,
  ...
}: let
  hostName = "klipper";
in {
  imports = [
    # Include results of the hardware scan.
    ./hardware-configuration.nix
    disko.nixosModules.default
    ./disko-config.nix
    ./impermanence.nix
    ./klipper
  ];

  boot.loader = {
    grub = {
      enable = true;
      efiSupport = true;
      useOSProber = true;
      efiInstallAsRemovable = true;
      device = "/dev/sda";
    };
    systemd-boot = {
      enable = false;
    };
  };

  networking = {
    inherit hostName;
    wireless = {
      enable = true;
      networks = {
        "Ergo Home" = {
          # SSID with spaces and/or special characters
          psk = secrets.wifi.psk; # (password will be written to /nix/store!)
        };
      };
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
