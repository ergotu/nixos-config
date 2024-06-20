{pkgs, ...}: {
  home.packages = with pkgs; [
    skopeo
    docker-compose
    dive # explore docker layers
    lazydocker # Docker terminal UI.

    kubectl
    kubebuilder
    istioctl
    kubevirt # virtctl
    kubernetes-helm
    fluxcd
    argocd
  ];

  programs = {
    k9s = {
      enable = true;
    };
  };
}
