{
  # required by impermanence
  fileSystems."/persistent".neededForBoot = true;

  disko.devices = {
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [
        "size=4G"
        "defaults"
        # set mode to 755, otherwise systemd will set it to 777, which cause problems.
        # relatime: Update inode access times relative to modify or change time.
        "mode=755"
      ];
    };

    disk.main = {
      type = "disk";
      # When using disko-install, we will overwrite this value from the commandline
      device = "/dev/sda"; # The device to partition
      content = {
        type = "gpt";
        partitions = {
          # The EFI & Boot partition
          boot = {
            size = "1M";
            type = "EF02";
          };
          ESP = {
            size = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          # The root partition
          root = {
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = ["-f"]; # Force override existing partition
              subvolumes = {
                # mount the top-level subvolume at /btr_pool
                # it will be used by btrbk to create snapshots
                "/" = {
                  mountpoint = "/btr_pool";
                  # btrfs's top-level subvolume, internally has an id 5
                  # we can access all other subvolumes from this subvolume.
                  mountOptions = ["subvolid=5"];
                };
                "@nix" = {
                  mountpoint = "/nix";
                  mountOptions = ["compress-force=zstd:1" "noatime"];
                };
                "@persistent" = {
                  mountpoint = "/persistent";
                  mountOptions = ["compress-force=zstd:1" "noatime"];
                };
                "@tmp" = {
                  mountpoint = "/tmp";
                  mountOptions = ["compress-force=zstd:1" "noatime"];
                };
                "@snapshots" = {
                  mountpoint = "/snapshots";
                  mountOptions = ["compress-force=zstd:1" "noatime"];
                };
                "@swap" = {
                  mountpoint = "/swap";
                  swap.swapfile.size = "16384M";
                };
              };
            };
          };
        };
      };
    };
  };
}
