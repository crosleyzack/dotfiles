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
        "CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC": "1",
        "DISABLE_TELEMETRY": "1",
        "DISABLE_ERROR_REPORTING": "1"
    },
    "permissions": {
        "allowBypassPermissions": false,
        "allow": [
            "Bash(* git diff *)",
            "Bash(* git log *)",
            "Bash(* git status *)",
            "Bash(* go test *)",
            "Bash(* go build *)",
            "Bash(* golangci-lint *)"
        ],
        "ask": [
            "Bash",
            "Bash(* find *)",
            "Bash(* rm *)",
            "WebFetch",
            "WebSearch"
        ],
        "deny": [
            "Read(*.pem)",
            "Read(credentials*)",
            "Read(secrets/*)",
            "Read(**/.env)",
            "Edit(*.pem)",
            "Edit(*.key)",
            "Edit(package-lock.json)",
            "Edit(**/.env)",
            "Write(*.pem)",
            "Write(*.key)",
            "Write(id_rsa*)",
            "Write(**/.env)",
            "Bash(* rm -rf *)",
            "Bash(* git push --force *)",
            "Bash(* git reset --hard *)",
            "Bash(* sudo *)",
            "Bash(* su *)",
            "Bash(* ssh *)",
            "Bash(* chmod 777 *)",
            "Bash(* nc*)",
            "Bash(* netcat *)",
            "Bash(* socat *)",
            "Bash(* nmap *)",
            "Bash(* masscan *)",
            "Bash(* passwd *)",
            "Bash(* mkfs *)",
            "Bash(* fdisk *)",
            "Bash(* parted *)",
            "Bash(* dd *)",
            "Bash(* crontab *)",
            "Bash(* kill *)",
            "Bash(* killall *)",
            "Bash(* >/dev/sd *)"
        ]
    },
    "hooks": {
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
    },
    "respectGitignore": true,
    "includeCoAuthoredBy": false,
    "cleanupPeriodDays": 14
}
    '';
  };
}
