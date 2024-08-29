{
  impermanence,
  myvars,
  pkgs,
  ...
}: {
  imports = [
    impermanence.nixosModules.impermanence
  ];

  environment.systemPackages = [
    # `sudo ncdu -x /`
    pkgs.ncdu
  ];

  # NOTE: impermanence only mounts the directory/file list below to /persistent
  # If the directory/file already exists in the root filesystem, you should
  # move those files/directories to /persistent first!
  environment.persistence."/persistent" = {
    # sets the mount option x-gvfs-hide on all the bind mounts
    # to hide them from the file manager
    hideMounts = true;
    directories = [
      "/etc/NetworkManager/system-connections"
      "/etc/nix/inputs"
      "/etc/agenix/"
      "/etc/secureboot"

      "/var/log"
      "/var/lib"

      # k3s related
      "/etc/iscsi"
      "/etc/rancher"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
    ];

    # the following directories will be passed to /persistent/home/$USER
    users."${myvars.username}" = {
      directories = [
        "vaults/personal"
        "vaults/work"

        "projects"
        "nixos-config"
        {
          directory = ".gnupg";
          mode = "0700";
        }
        {
          directory = ".ssh";
          mode = "0700";
        }
        {
          directory = ".local/share/keyrings";
          mode = "0700";
        }

        # misc
        ".config/pulse"
        ".pki"
        ".steam"

        # RDP
        ".config/remmina"
        ".config/freerdp"

        # browsers
        ".mozilla" # firefox
        ".config/google-chrome"

        # neovim / remmina / flatpak/ ...
        ".local/share"
        ".local/state"
      ];

      files = [
      ];
    };
  };
}
