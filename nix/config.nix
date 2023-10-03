{
  # allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
  #   "roon-server"
  #   "vscode"
  # ];
  allowUnfree = true;
  # allowUnfreePackages = ["vscode"];
}
