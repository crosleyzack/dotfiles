{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    claude-code
  ];
  # config file
  home.file.claude = {
    enable = true;
    target = ".claude/settings.json";
    text = ''
{
    "permissions": {
        "deny": [
            "Read(file_path:*.pem)",
            "Read(file_path:credentials*)",
            "Read(file_path:secrets/*)",
            
            "Edit(file_path:*.pem)",
            "Edit(file_path:*.key)",
            "Edit(file_path:package-lock.json)",
            
            "Write(file_path:*.pem)",
            "Write(file_path:*.key)",
            "Write(file_path:id_rsa*)",
            
            "Bash(command:*rm -rf*)",
            "Bash(command:*git push --force*)",
            "Bash(command:*git reset --hard*)",
            "Bash(command:*sudo*)",
            "Bash(command:*chmod 777*)"
        ]
    },
    "hooks": [
        {
        "event": "PreToolUse",
        "path": ".claude/hooks/bash/security-gate.sh"
        }
    ],
    "env": {
        "SHELL": "${config.home.homeDirectory}/.nix-profile/bin/zsh"
    }
}
    '';
  };
}
