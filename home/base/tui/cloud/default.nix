{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.custom.cloud;
in {
  options.custom.cloud.enabled = lib.mkEnableOption "Cloud Tools";

  config = lib.mkIf cfg.enabled {
    home.packages = with pkgs; [
      # infrastructure as code
      # pulumi
      # pulumictl
      # tf2pulumi
      # crd2pulumi
      # pulumiPackages.pulumi-random
      # pulumiPackages.pulumi-command
      # pulumiPackages.pulumi-aws-native
      # pulumiPackages.pulumi-language-go
      # pulumiPackages.pulumi-language-python
      # pulumiPackages.pulumi-language-nodejs

      # aws
      awscli2
      ssm-session-manager-plugin # Amazon SSM Session Manager Plugin
      aws-iam-authenticator
      eksctl

      # GCP
      google-cloud-sdk

      # cloud tools that nix do not have cache for.
      terraform
      terraformer # generate terraform configs from existing cloud resources
      packer # machine image builder
    ];
  };
}
