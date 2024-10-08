{
  catppuccin,
  lib,
  ...
}: {
  boot.loader = {
    systemd-boot = {
      # we use Git for version control, so we don't need to keep too many generations.
      configurationLimit = lib.mkDefault 10;
      # pick the highest resolution for systemd-boot's console.
      consoleMode = lib.mkDefault "max";
    };
    grub = {
      configurationLimit = lib.mkDefault 10;
    };
  };

  # for power management
  services = {
    power-profiles-daemon = {
      enable = true;
    };
    upower.enable = true;
  };

  imports = [catppuccin.nixosModules.catppuccin];
  catppuccin = {
    enable = true;
    flavor = "mocha";
  };
}
