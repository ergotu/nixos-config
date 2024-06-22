_: let
  hostname = "bazzite";
in {
  networking.hostName = hostname;
  networking.computerName = hostname;
  system.defaults.smb.netBIOSName = hostname;
}
