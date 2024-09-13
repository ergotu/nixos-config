{
  inputs,
  lib,
}: {
  networking = import ./networking.nix {inherit lib;};

  username = "ergotu";
  domain = inputs.nix-secrets.domain;
  userFullName = inputs.nix-secrets.full-name;
  handle = "ergotu";
  userEmail = inputs.nix-secrets.user-email;
  gitHubEmail = "17287858+ergotu@users.noreply.github.com.";
  workEmail = inputs.nix-secrets.work-email;
  persistFolder = "/persist";

  # System-specific settings (FIXME: Likely make options)
  isMinimal = false; # Used to indicate nixos-installer build
  isWork = false; # Used to indicate a host that uses work resources
  scaling = "1"; # Used to indicate what scaling to use. Floating point number
}
