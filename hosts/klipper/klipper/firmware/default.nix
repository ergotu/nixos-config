{
  lib,
  writeShellApplication,
  gnumake,
  pkgsCross,
  klipper,
  klipper-firmware,
  python3,
  avrdude,
  stm32flash,
  coreutils-full,
  gcc-arm-embedded,
  gcc,
  libusb1,
  dfu-util,
  pkg-config,
  flashMethodOverride ? null,
  mcu ? "mcu",
  flashDevice ? "/dev/null",
  firmwareConfig ? ./simulator.cfg,
}: let
  supportedArches = ["avr" "stm32" "lpc176x"];
  matchBoard = with builtins; match ''^.*CONFIG_BOARD_DIRECTORY="([a-zA-Z0-9_]+)".*$'' (readFile firmwareConfig);
  boardArch =
    if matchBoard == null
    then null
    else builtins.head matchBoard;
  workingDir = "/tmp/flash.${mcu}/";
  flashMethod =
    if flashMethodOverride == null
    then
      (
        if (boardArch == "stm32")
        then "serialflash"
        else "flash"
      )
    else flashMethodOverride;
in
  writeShellApplication {
    name = "klipper-flash-${mcu}";
    runtimeInputs =
      [
        python3
        pkgsCross.avr.stdenv.cc
        gnumake
        coreutils-full
        gcc-arm-embedded
        gcc
        libusb1
        dfu-util
        pkg-config
      ]
      ++ lib.optionals (boardArch == "avr") [avrdude]
      ++ lib.optionals (boardArch == "stm32") [stm32flash];
    text =
      if (builtins.elem boardArch supportedArches)
      then ''
        mkdir -p "${workingDir}"
        cp -r "${klipper-firmware}"/* "${workingDir}"
        make -C ${klipper.src} FLASH_DEVICE="${toString flashDevice}" OUT="${workingDir}" KCONFIG_CONFIG="${workingDir}config" ${flashMethod}
        rm -rf ${workingDir}
      ''
      else ''
        printf "Flashing Klipper firmware to your board is not supported yet.\n"
        printf "Please use the compiled firmware at ${klipper-firmware} and flash it using the tools provided for your microcontroller."
        exit 1
      '';
  }
