{ pkgs, ... }:

{
  home.packages = with pkgs; [
    yubikey-manager
  ];

  systemd.user.services.yubikey-touch-detector = {
    Unit.Description = "YubiKey touch notifier";
    Service.ExecStart = "${pkgs.yubikey-touch-detector}/bin/yubikey-touch-detector --libnotify";
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
