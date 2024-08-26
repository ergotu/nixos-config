{pkgs, ...}: {
  environment.systemPackages = [pkgs.tailscale];

  services.tailscale = {
    enable = true;
    interfaceName = "tailscale0";
    openFirewall = true;
    useRoutingFeatures = "client";
  };
}
