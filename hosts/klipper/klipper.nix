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

  users.users.klipper = {
    isSystemUser = true;
    group = "klipper";
  };
  users.groups.klipper = {};

  security.polkit.enable = true;

  services.klipper = {
    enable = true;
    user = "klipper";
    group = "klipper";
    configFile = ./printer.conf;
    mutableConfig = true;
    mutableConfigFolder = "/var/lib/klipper/config";
    logFile = "/var/lib/klipper/klipper.log";
  };

  services.moonraker = {
    user = "klipper";
    group = "klipper";
    enable = true;
    address = "0.0.0.0";
    allowSystemControl = true;
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

  services.fluidd = {
    enable = true;
    nginx.extraConfig = ''
      client_max_body_size 1G;
    '';
  };
}
