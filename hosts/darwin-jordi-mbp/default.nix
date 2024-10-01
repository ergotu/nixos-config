_: let
  hostname = "jordi-mbp";
in {
  networking.hostName = hostname;
  networking.computerName = hostname;
  system.defaults.smb.NetBIOSName = hostname;
  system.stateVersion = 5;
}
