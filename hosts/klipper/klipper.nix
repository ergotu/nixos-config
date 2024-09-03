{pkgs, ...}: let
  firmware = pkgs.klipper-firmware.override {
    mcu = "octopus-v1.1";
    firmwareConfig = ./config;
    gcc-arm-embedded = pkgs.gcc-arm-embedded-10;
  };
  flasher = pkgs.callPackage ./klipper-flash.nix {
    flashMethodOverride = "flash";
    mcu = "octopus-v1.1";
    klipper-firmware = firmware;
    firmwareConfig = ./config;
    flashDevice = "/dev/serial/by-id/usb-Klipper_stm32f429xx_3A0034001350344D30363120-if00";
    gcc-arm-embedded = pkgs.gcc-arm-embedded-10;
  };
in {
  environment.systemPackages = [
    firmware
    flasher
    pkgs.klipperscreen
  ];

  services.xserver.enable = true;

  services.klipper = {
    enable = true;
    user = "ergotu";
    group = "ergotu";
    configFile = ./printer.conf;
    mutableConfig = true;
    mutableConfigFolder = "/var/lib/klipper/config";
    logFile = "/var/lib/klipper/klipper.log";
  };

  services.moonraker = {
    user = "ergotu";
    enable = true;
    address = "0.0.0.0";
    stateDir = "/var/lib/klipper";
    settings = {
      octoprint_compat = {};
      history = {};
      authorization = {
        force_logins = false;
        cors_domains = [
          "*"
        ];
        trusted_clients = [
          "10.0.0.0/8"
          "127.0.0.0/8"
          "169.254.0.0/16"
          "172.16.0.0/12"
          "192.168.1.0/24"
          "192.168.99.0/24"
          "FE80::/10"
          "::1/128"
        ];
      };
    };
  };

  services.fluidd.enable = true;
  services.fluidd.nginx.locations."/webcam".proxyPass = "http://127.0.0.1:8080/stream";
  services.nginx.clientMaxBodySize = "1000m";

  virtualisation = {
    docker = {
      enable = true;
      daemon.settings = {
        # enables pulling using containerd, which supports restarting from a partial pull
        # https://docs.docker.com/storage/containerd/
        "features" = {"containerd-snapshotter" = true;};
      };

      # start dockerd on boot.
      # This is required for containers which are created with the `--restart=always` flag to work.
      enableOnBoot = true;
    };
  };
}
