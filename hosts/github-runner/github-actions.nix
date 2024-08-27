{
  srvos,
  mylib,
  ...
}: {
  imports = [
    srvos.nixosModules.roles-github-actions-runner
  ];

  roles.github-actions-runner = {
    url = "https://github.com/ergotu";
    count = 10;
    name = "github-runner";
    githubApp = {
      id = "980530";
      login = "ergotu";
      privateKeyFile = mylib.relativeToRoot "secrets/github_app_private_key.pem";
    };
  };
}
