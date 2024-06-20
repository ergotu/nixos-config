{catppuccin, ...}: {
  imports = [
    catppuccin.homeManagerModules.catppuccin
  ];

  catppuccin = {
    enable = true;
    flavor = "mocha";
  };

  programs.zsh.completionInit = "autoload -U compinit && compinit -i";
}
