{
  # allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
  #   "roon-server"
  #   "vscode"
  # ];
  allowUnfree = true;
  permittedInsecurePackages = [
   "electron-24.8.6"
  ];
  # allowUnfreePackages = ["vscode"];
}
