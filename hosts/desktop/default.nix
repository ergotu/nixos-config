{
  lib,
  nixos-hardware,
  config,
  disko,
  ...
}: let
  hostName = "desktop";
  nividiaPackage = config.hardware.nvidia.package;
in {
  imports = [
    nixos-hardware.nixosModules.common-cpu-amd

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

    open = lib.mkOverride 990 (nividiaPackage ? open && nividiaPackage ? firmware);
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
