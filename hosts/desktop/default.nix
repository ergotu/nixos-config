{
  lib,
  disko,
  ...
}: let
  hostName = "desktop";
in {
  imports = [
    ./hardware-configuration.nix
    disko.nixosModules.default
    ./disko-config.nix
    ./impermanence.nix
  ];

  networking = {
    inherit hostName;
    networkmanager.enable = true;
  };

  # For Nvidia GPU
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/os-specific/linux/nvidia-x11/default.nix
    # package = config.boot.kernelPackages.nvidiaPackages.stable;

    open = false;
    # required by most wayland compositors!
    modesetting.enable = true;
    powerManagement.enable = true;
  };
  hardware.nvidia-container-toolkit.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  system.stateVersion = "24.05";
}
