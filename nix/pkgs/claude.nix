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
    "env": {
        "SHELL": "${config.home.homeDirectory}/.nix-profile/bin/zsh",
        "CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC": 1,
        "DISABLE_TELEMETRY": 1,
        "DISABLE_ERROR_REPORTING": 1
    },
    "permissions": {
        "disableBypassPermissionsMode": "disable",
        "allow": [
            "Bash(command:git diff:*)",
            "Bash(command:git log:*)",
            "Bash(command:git status:*)",
            "Bash(command:go test:*)",
            "Bash(command:go build:*)",
            "Bash(command:golangci-lint:*)"
        ],
        "ask": [
            "Bash",
            "Bash(find:*)",
            "Bash(rm:*)",
            "WebFetch",
            "WebSearch"
        ],
        "deny": [
            "Read(file_path:*.pem)",
            "Read(file_path:credentials*)",
            "Read(file_path:secrets/*)",
            "Read(file_path:secrets/*)",
            "Read(file_path:**/.env)",
            
            "Edit(file_path:*.pem)",
            "Edit(file_path:*.key)",
            "Edit(file_path:package-lock.json)",
            "Edit(file_path:**/.env)",
            
            "Write(file_path:*.pem)",
            "Write(file_path:*.key)",
            "Write(file_path:id_rsa*)",
            "Write(file_path:**/.env)",
            
            "Bash(command:*rm -rf*)",
            "Bash(command:*git push --force*)",
            "Bash(command:*git reset --hard*)",
            "Bash(command:*sudo*)",
            "Bash(command:*su*)",
            "Bash(command:*ssh*)",
            "Bash(command:*chmod 777*)",
            "Bash(command:*nc*)",
            "Bash(command:*netcat*)",
            "Bash(command:*socat*)",
            "Bash(command:*nmap*)",
            "Bash(command:*masscan*)",
            "Bash(command:*passwd*)",
            "Bash(command:*mkfs*)",
            "Bash(command:*fdisk*)",
            "Bash(command:*parted*)",
            "Bash(command:*dd*)",
            "Bash(command:*crontab*)",
            "Bash(command:*kill*)",
            "Bash(command:*killall*)",
            "Bash(command:*>/dev/sd*)"
        ]
    },
    "hooks": [
        "PostToolUse": [
            {
                "matcher": "Write|Edit",
                "hooks": [
                    {
                    "type": "command",
                    "command": "gofmt -w \"$FILE_PATH\" 2>/dev/null || true",
                    "async": true
                    }
                ]
            }
        ],
        "UserPromptSubmit": [
            {
                "hooks": [
                    {
                    "type": "command",
                    "command": "git diff --stat 2>/dev/null || true",
                    "statusMessage": "Checking git status..."
                    }
                ]
            }
        ]
    ],
    "respectGitignore": true,
    "includeCoAuthoredBy": false,
    "cleanupPeriodDays": 14
}
    '';
  };
}
