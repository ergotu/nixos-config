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
      plugin = {
        plugins = {
          toggle-helmrelease = {
            shortCut = "Shift-T";
            confirm = true;
            scopes = ["helmreleases"];
            description = "Suspend or resume a HelmRelease";
            command = "bash";
            background = false;
            args = [
              "-c"
              "suspended=$(kubectl --context $CONTEXT get helmreleases -n $NAMESPACE -o=custom-columns=TYPE:.spec.suspend | tail -1);"
              "verb=$([ $suspended = \"true\" ] && echo \"resume\" || echo \"suspend\");"
              "flux"
              "$verb helmrelease"
              "--context $CONTEXT"
              "-n $NAMESPACE $NAME"
              "| less -K"
            ];
          };
        };
      };
    };
  };
}
