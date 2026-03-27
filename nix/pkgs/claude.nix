{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    claude-code
  ];
  # config file
  home.file.claude_settings = {
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
            "Bash(* --version)",
            "Bash(* --help)",
            "Bash(grep *)",
            "Bash(cat *)",
            "Bash(ls *)",
            "Bash(git diff *)",
            "Bash(git log *)",
            "Bash(git status *)",
            "Bash(go test *)",
            "Bash(go doc *)",
            "Bash(go build *)",
            "Bash(golangci-lint *)",
            "Bash(terraform state show *)",
            "Bash(terraform state list *)",
            "Bash(gcloud run services describe *)",
            "Bash(gcloud run services list *)",
            "Bash(gcloud run jobs describe *)",
            "Bash(gcloud run jobs list *)",
            "Bash(gcloud logging read *)",
            "Bash(docker ps *)",
            "Bash(docker logs *)",
            "Bash(docker inspect *)",
            "Bash(docker images *)",
            "Bash(kubectl get *)",
            "Bash(kubectl describe *)",
            "Bash(kubectl logs *)",
            "Bash(aws * describe-* *)",
            "Bash(aws * list-* *)",
            "Bash(aws * get-* *)",
            "Bash(terraform plan *)",
            "Bash(terraform show *)",
            "Bash(terraform validate *)",
            "Bash(head *)",
            "Bash(tail *)",
            "Bash(find *)",
            "Read"
        ], 
        "ask": [
            "Write",
            "Edit",
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
  home.file.claude = {
    enable = true;
    target = ".claude/CLAUDE.md";
    text = ''
Read all links you are given; they have critical context
You can run read-only commands, but always ask before writing
Always show you work and explain why you are doing this
Go packages should always have an interface, a struct implementing that interface, a mock of the interface, and comprehensive tests for every method
Function test should always compare the full output object to the expected output object; use cmp.Diff for structs
   '';
  };
}
