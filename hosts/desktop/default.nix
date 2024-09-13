{inputs, ...}: {
  imports = [
    #################### Every Host Needs This ####################
    ./hardware-configuration.nix

    #################### Hardware Modules ####################
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-gpu-nvidia
    # inputs.hardware.nixosModules.common-pc-ssd

    #################### Disk Layout ####################
    inputs.disko.nixosModules.disko
    ./disko-config.nix
  ];

  networking = {
    hostName = "desktop";
    networkmanager.enable = true;
    enableIPv6 = true;
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    timeout = 3;
  };

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
