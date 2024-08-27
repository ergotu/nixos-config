{
  disko,
  srvos,
  ...
}: let
  hostName = "github-runner";
in {
  imports = [
    # Include results of the hardware scan.
    ./hardware-configuration.nix
    disko.nixosModules.default
    ./disko-config.nix
    ./impermanence.nix
    ./github-actions.nix
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
  };

  # programs.nix-ld.enable = true;

  services.qemuGuest.enable = true;
  boot.kernel.sysctl = {
    # --- filesystem --- #
    # increase the limits to avoid running out of inotify watches
    "fs.inotify.max_user_watches" = 524288;
    "fs.inotify.max_user_instances" = 1024;

    # --- network --- #
    "net.bridge.bridge-nf-call-iptables" = 1;
    "net.core.somaxconn" = 32768;
    "net.ipv4.ip_forward" = 1;
    "net.ipv4.conf.all.forwarding" = 1;
    "net.ipv4.neigh.default.gc_thresh1" = 4096;
    "net.ipv4.neigh.default.gc_thresh2" = 6144;
    "net.ipv4.neigh.default.gc_thresh3" = 8192;
    "net.ipv4.neigh.default.gc_interval" = 60;
    "net.ipv4.neigh.default.gc_stale_time" = 120;

    "net.ipv6.conf.all.disable_ipv6" = 1; # disable ipv6

    # --- memory --- #
    "vm.swappiness" = 0; # don't swap unless absolutely necessary
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
