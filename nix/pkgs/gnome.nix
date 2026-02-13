{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # packages that only apply with window managers
    wmctrl
    xorg.xrandr
  ];
  # This sets up the gnome environment to preferred settings, a
  #  pseudo-i3 environment with fixed desktops and shortcuts to
  #  move between them
  dconf.settings = {
      # fractional scaling for modern display environment
      "org/gnome/mutter" = {
        experimental-features = [
            "scale-monitor-framebuffer"
        ];
        edge-tiling = false;
      };
      # turn off animations for performance
      "org/gnome/desktop/interface" = {
        enable-animations = false;
        color-scheme      = "prefer-dark";
      };
      # fixed 10 workspaces like i3 environment
      "org/gnome/desktop/wm/preferences" = {
        num-workspaces = 10;
      };
      "org/gnome/desktop/wm/keybindings" = {
        # super-# goes to that virtual desktop
        switch-to-workspace-1  = ["<Super>1"];
        switch-to-workspace-2  = ["<Super>2"];
        switch-to-workspace-3  = ["<Super>3"];
        switch-to-workspace-4  = ["<Super>4"];
        switch-to-workspace-5  = ["<Super>5"];
        switch-to-workspace-6  = ["<Super>6"];
        switch-to-workspace-7  = ["<Super>7"];
        switch-to-workspace-8  = ["<Super>8"];
        switch-to-workspace-9  = ["<Super>9"];
        switch-to-workspace-10 = ["<Super>0"];
        # super-shift-# moves window to that virtual desktop
        move-to-workspace-1  = ["<Super><Shift>1"];
        move-to-workspace-2  = ["<Super><Shift>2"];
        move-to-workspace-3  = ["<Super><Shift>3"];
        move-to-workspace-4  = ["<Super><Shift>4"];
        move-to-workspace-5  = ["<Super><Shift>5"];
        move-to-workspace-6  = ["<Super><Shift>6"];
        move-to-workspace-7  = ["<Super><Shift>7"];
        move-to-workspace-8  = ["<Super><Shift>8"];
        move-to-workspace-9  = ["<Super><Shift>9"];
        move-to-workspace-10 = ["<Super><Shift>0"];
        # cycle through workspaces
        cycle-windows          = ["<Super>Tab"];
        cycle-windows-backward = ["<Super><Shift>Tab"];
        cycle-group            = ["<Super>a"];
        cycle-group-backward   = ["<Super><Shift>a"];
        # move windows to location within workspace
        move-to-side-e        = ["<Super>l"];
        move-to-side-n        = ["<Super>k"];
        move-to-side-s        = ["<Super>j"];
        move-to-side-w        = ["<Super>h"];
        maximize-horizontally = ["<Super>s"];
        maximize-vertically   = ["<Super>v"];
        maximize              = ["<Super>Up"];
        unmaximize            = ["<Super>Down"];
        toggle-fullscreen     = ["<Super>f"];
      };
      # autohide sidebar, you don't need it
      "org/gnome/shell/extensions/dash-to-dock" = {
        dock-fixed  = false;
        intellihide = true;
      };
      "org/gnome/settings-daemon/plugins/media-keys" = {
        terminal = ["<Super>Return"];
      };
  };
}
