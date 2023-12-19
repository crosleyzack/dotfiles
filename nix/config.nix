{
  # allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
  #   "roon-server"
  #   "vscode"
  # ];
  allowUnfree = true;
  permittedInsecurePackages = [
   "electron-24.8.6"
   "ruby-2.7.8"
   "openssl-1.1.1w"
  ];
  # allowUnfreePackages = ["vscode"];
}
