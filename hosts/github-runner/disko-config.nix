{lib, ...}: {
  # required by impermanence
  fileSystems."/persistent".neededForBoot = true;

  boot.initrd.postDeviceCommands = lib.mkAfter ''
    mkdir /btrfs_tmp
    mount /btr_pool /btrfs_tmp
    if [[ -e /btrfs_tmp/root ]]; then
        mkdir -p /btrfs_tmp/old_roots
        timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
        mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
    fi

    delete_subvolume_recursively() {
        IFS=$'\n'
        for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
            delete_subvolume_recursively "/btrfs_tmp/$i"
        done
        btrfs subvolume delete "$1"
    }

    for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
        delete_subvolume_recursively "$i"
    done

    btrfs subvolume create /btrfs_tmp/root
    umount /btrfs_tmp
  '';

  disko.devices = {
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
                "@root" = {
                  mountpoint = "/";
                  mountOptions = ["compress-force=zstd:1" "noatime"];
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
