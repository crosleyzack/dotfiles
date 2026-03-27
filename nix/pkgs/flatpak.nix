{ config, pkgs, lib, ... }:

let
  # Common apps installed on all systems
  basePackages = [
    "com.spotify.Client"               # Music streaming
    "md.obsidian.Obsidian"             # Note-taking
    "me.proton.Pass"                   # Password manager
  ];

  # System-specific packages based on NIX_SYSTEM_ID
  systemPackages = {
    framework = [
      "com.slack.Slack"                 # Team communication
    ];

    lenovo = [
      "org.signal.Signal"               # Secure messaging
      "io.podman_desktop.PodmanDesktop" # Container management
      "org.librecad.librecad"           # CAD application
      "org.gimp.GIMP"                   # Image editing
      "com.valvesoftware.Steam"         # Gaming platform
      "me.proton.Pass"                  # Password manager
    ];

    google = [
      # Google workstation specific apps
    ];
  };

  # Get the system ID from environment variable (set in each device's home.nix)
  systemId = config.home.sessionVariables.NIX_SYSTEM_ID or "default";

  # Combine base packages + system-specific packages
  allPackages = basePackages ++ (systemPackages.${systemId} or []);
in
{
  services.flatpak = {
    # Enable Flatpak integration
    enable = true;

    # Automatically manage remotes (adds Flathub)
    remotes = [{
      name = "flathub";
      location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
    }];

    # Declaratively install packages (automatic based on NIX_SYSTEM_ID)
    packages = allPackages;

    # Automatically update packages
    update.auto = {
      enable = true;
      onCalendar = "weekly";  # Run weekly updates
    };
  };
}
