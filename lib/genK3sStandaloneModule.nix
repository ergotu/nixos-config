{
  pkgs,
  kubeconfigFile,
  masterHost,
  kubeletExtraArgs ? [],
  nodeLabels ? [],
  nodeTaints ? [],
  disableFlannel ? false,
  ...
}: let
  lib = pkgs.lib;
  package = pkgs.k3s_1_29;
in {
  environment.systemPackages = with pkgs; [
    package
    k9s
    kubectl
    istioctl
    kubernetes-helm
    cilium-cli
    fluxcd

    skopeo
    dive # explore docker layers
  ];

  services.k3s = {
    enable = true;
    inherit package;

    role = "server";
    # https://docs.k3s.io/cli/server
    extraFlags = let
      flagList =
        [
          "--write-kubeconfig=${kubeconfigFile}"
          "--write-kubeconfig-mode=644"
          "--service-node-port-range=80-32767"
          "--data-dir /var/lib/rancher/k3s"
          # disable some features we don't need
          "--disable-helm-controller" # we use fluxcd instead
          "--disable=traefik"
          "--disable-network-policy"
          "--tls-san=${masterHost}"
        ]
        ++ (map (label: "--node-label=${label}") nodeLabels)
        ++ (map (taint: "--node-taint=${taint}") nodeTaints)
        ++ (map (arg: "--kubelet-arg=${arg}") kubeletExtraArgs)
        ++ (lib.optionals disableFlannel ["--flannel-backend=none"]);
    in
      lib.concatStringsSep " " flagList;
  };

  # create symlinks to link k3s's cni directory to the one used by almost all CNI plugins
  # such as multus, calico, etc.
  systemd.tmpfiles.rules = [
    "L+ /opt/cni/bin - - - - /var/lib/rancher/k3s/data/current/bin"
    # If you have disabled flannel, you will have to create the directory via a tmpfiles rule
    "D /var/lib/rancher/k3s/agent/etc/cni/net.d 0751 root root - -"
    # Link the CNI config directory
    "L+ /etc/cni/net.d - - - - /var/lib/rancher/k3s/agent/etc/cni/net.d"
  ];
}
