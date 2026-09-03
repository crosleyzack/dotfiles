{ config, pkgs, lib, ... }:

let
  cfg = config.my.claude;

  # Override for a single session with `claude --effort <low|medium|high|xhigh|max>`
  # (or `claude -c --effort <level>` to resume the current conversation at that level).
  defaultEffort = "high";

  claudeDir = "${config.home.homeDirectory}/.claude";

  # "sandbox" profile: a throwaway VM where git changes in upstream 
  # are the only thing worth protecting
  sandboxPermissions = {
    permissions = {
      # File edits go through with no prompt. Bash still obeys the lists below.
      defaultMode = "acceptEdits";

      # Local files are disposable on this machine, thus these tools need no
      # prompt. A bare name allows the tool for every path.
      allow = [
        "Read"
        "Glob"
        "Grep"
        "Edit"
        "Write"
        "NotebookEdit"
        "WebFetch"
        "WebSearch"
      ]
      # Two rules for each tool: one for the start of the command, one
      # for a later position (a pipe, a subshell, or an argument).
      ++ lib.concatMap (tool: [
        "Bash(${tool} *)"
        "Bash(* ${tool} *)"
      ]) allowTools;
      deny = lib.concatMap (tool: [
        "Bash(${tool} *)"
        "Bash(* ${tool} *)"
      ]) sandboxBlocked;
    };
    hooks.PreToolUse = [
      {
        matcher = "Bash";
        hooks = [
          {
            type = "command";
            command = "${sandboxHook}";
          }
        ];
      }
    ];
  };

  # restricted permissions trying to limit
  restrictedPermissions = {
    permissions = {
      # Lock this machine out of bypassPermissions mode. The key name matters:
      # "allowBypassPermissions" is not a setting Claude Code reads, thus it did
      # nothing here before.
      disableBypassPermissionsMode = "disable";
      allow = [
        "Bash(* --version)"
        "Bash(* --help)"
        "Bash(grep *)"
        "Bash(cat *)"
        "Bash(ls *)"
        "Bash(head *)"
        "Bash(tail *)"
        "Bash(find *)"
        "Bash(git diff *)"
        "Bash(git log *)"
        "Bash(git status *)"
        "Bash(go test *)"
        "Bash(go doc *)"
        "Bash(go build *)"
        "Bash(golangci-lint *)"
        "Bash(terraform plan *)"
        "Bash(terraform show *)"
        "Bash(terraform validate *)"
        "Bash(terraform state show *)"
        "Bash(terraform state list *)"
        "Bash(gcloud run services describe *)"
        "Bash(gcloud run services list *)"
        "Bash(gcloud run jobs describe *)"
        "Bash(gcloud run jobs list *)"
        "Bash(gcloud logging read *)"
        "Bash(docker ps *)"
        "Bash(docker logs *)"
        "Bash(docker inspect *)"
        "Bash(docker images *)"
        "Bash(kubectl get *)"
        "Bash(kubectl describe *)"
        "Bash(kubectl logs *)"
        "Bash(aws * describe-* *)"
        "Bash(aws * list-* *)"
        "Bash(aws * get-* *)"
        "Read(${config.home.homeDirectory}/**)"
        "Read(/tmp/claude*/**)"
      ];
      ask = [
        "Edit(${config.home.homeDirectory}/**)"
        "Edit(/tmp/claude*/**)"
        "WebFetch"
        "WebSearch"
        "Bash(terraform apply *)"
        "Bash(terraform import *)"
        "Bash(terraform taint *)"
        "Bash(terraform state mv *)"
        "Bash(gcloud * create *)"
        "Bash(gcloud * update *)"
        "Bash(gcloud * deploy *)"
        "Bash(gcloud run deploy *)"
        "Bash(kubectl apply *)"
        "Bash(kubectl create *)"
        "Bash(kubectl delete *)"
        "Bash(kubectl edit *)"
        "Bash(kubectl patch *)"
        "Bash(kubectl scale *)"
        "Bash(kubectl rollout restart *)"
        "Bash(kubectl exec *)"
        "Bash(kubectl port-forward *)"
        "Bash(docker rm *)"
        "Bash(docker rmi *)"
        "Bash(docker kill *)"
        "Bash(docker stop *)"
        "Bash(docker exec *)"
        "Bash(aws * put-* *)"
        "Bash(aws * create-* *)"
        "Bash(aws * update-* *)"
        "Bash(aws * modify-* *)"
        "Bash(aws * stop-* *)"
        "Bash(npm install *)"
        "Bash(npm ci *)"
        "Bash(yarn install *)"
        "Bash(pnpm install *)"
        "Bash(npm publish *)"
        "Bash(pip install *)"
        "Bash(go get *)"
        "Bash(go install *)"
        "Bash(helm install *)"
        "Bash(helm upgrade *)"
        "Bash(ansible-playbook *)"
        "Bash(git add *)"
        "Bash(git commit *)"
        "Bash(git push *)"
        "Bash(git pull *)"
        "Bash(git merge *)"
        "Bash(git rebase *)"
        "Bash(git cherry-pick *)"
      ];
      deny = [
        "Read(*.pem)"
        "Read(credentials*)"
        "Read(secrets/*)"
        "Read(**/.env)"
        "Read(**/.env.*)"
        "Read(**/*password*)"
        "Read(**/*secret*)"
        "Read(**/*token*)"
        "Read(${config.home.homeDirectory}/.ssh/**)"
        "Read(id_rsa*)"
        "Read(id_dsa*)"
        "Read(id_ecdsa*)"
        "Read(id_ed25519*)"
        "Read(*.ppk)"
        "Read(authorized_keys)"
        "Read(known_hosts)"
        "Read(*.keystore)"
        "Read(*.jks)"
        "Read(*.p12)"
        "Read(*.pfx)"
        "Read(*.ovpn)"
        "Read(${config.home.homeDirectory}/.aws/**)"
        "Read(${config.home.homeDirectory}/.config/gcloud/**)"
        "Read(${config.home.homeDirectory}/.azure/**)"
        "Read(${config.home.homeDirectory}/.kube/config)"
        "Read(${config.home.homeDirectory}/.docker/config.json)"
        "Read(${config.home.homeDirectory}/.gnupg/**)"
        "Read(${config.home.homeDirectory}/.password-store/**)"
        "Edit(*.pem)"
        "Edit(*.key)"
        "Edit(id_rsa*)"
        "Edit(package-lock.json)"
        "Edit(**/.env)"
        "Edit(**/.env.*)"
        "Edit(**/*password*)"
        "Edit(**/*secret*)"
        "Edit(**/*token*)"
        "Edit(${config.home.homeDirectory}/.ssh/**)"
        "Edit(*.keystore)"
        "Edit(*.jks)"
        "Edit(*.p12)"
        "Edit(*.pfx)"
        "Edit(${config.home.homeDirectory}/.aws/**)"
        "Edit(${config.home.homeDirectory}/.config/gcloud/**)"
        "Edit(${config.home.homeDirectory}/.kube/config)"
        "Edit(${config.home.homeDirectory}/.gnupg/**)"
        "Edit(${config.home.homeDirectory}/.password-store/**)"
        "Bash(* rm -rf *)"
        "Bash(* git push --force *)"
        "Bash(* git yolo *)"
        "Bash(* git reset --hard *)"
        "Bash(* sudo *)"
        "Bash(* su *)"
        "Bash(* ssh *)"
        "Bash(* chmod 777 *)"
        "Bash(* nc*)"
        "Bash(* netcat *)"
        "Bash(* socat *)"
        "Bash(* nmap *)"
        "Bash(* masscan *)"
        "Bash(* passwd *)"
        "Bash(* mkfs *)"
        "Bash(* fdisk *)"
        "Bash(* parted *)"
        "Bash(* dd *)"
        "Bash(* crontab *)"
        "Bash(* kill *)"
        "Bash(* killall *)"
        "Bash(* >/dev/sd *)"
        "Bash(* curl * | bash *)"
        "Bash(* wget * | bash *)"
        "Bash(* curl * | sh *)"
        "Bash(* wget * | sh *)"
        "Bash(* eval *)"
        "Bash(* exec *)"
        "Bash(* systemctl *)"
        "Bash(* useradd *)"
        "Bash(* usermod *)"
        "Bash(* userdel *)"
        "Bash(* mount *)"
        "Bash(* umount *)"
        "Bash(* iptables *)"
        "Bash(* ufw *)"
        "Bash(* chown -R *)"
        "Bash(* docker run --privileged *)"
        "Bash(* insmod *)"
        "Bash(* rmmod *)"
        "Bash(* modprobe *)"
        "Bash(* pkexec *)"
        "Bash(* doas *)"
        "Bash(* terraform destroy *)"
        "Bash(* terraform state rm *)"
        "Bash(* terraform force-unlock *)"
        "Bash(* terraform workspace delete *)"
        "Bash(* gcloud * delete *)"
        "Bash(* gcloud projects delete *)"
        "Bash(* gcloud sql instances delete *)"
        "Bash(* gcloud container clusters delete *)"
        "Bash(* kubectl delete namespace *)"
        "Bash(* kubectl delete pv *)"
        "Bash(* kubectl delete pvc *)"
        "Bash(* kubectl drain *)"
        "Bash(* docker system prune *)"
        "Bash(* docker volume prune *)"
        "Bash(* docker network prune *)"
        "Bash(* aws * delete-* *)"
        "Bash(* aws * terminate-* *)"
        "Bash(* aws rds delete-* *)"
        "Bash(* aws s3 rm * --recursive *)"
        "Bash(* aws s3api delete-* *)"
        "Bash(* helm uninstall *)"
        "Bash(* helm delete *)"
        "Bash(* kind delete cluster *)"
        "Bash(* k3d cluster delete *)"
        "Bash(* vagrant destroy *)"
        "Bash(* npm unpublish *)"
      ];
    };
  };

  # Tools that the "sandbox" profile blocks. This list makes the deny rules
  # above and the word list in the hook below. The hook tests the whole command
  # text for each word, thus a word here also blocks the tool it names.
  sandboxBlocked = [
    "terraform" "gcloud" "kubectl" "aws" "helm" "k3d" "ssh"
    "redis" "mysql" "postgres" "psql" "cloud-sql-proxy" "ykman"
    "crane push" "crane delete" "gh pr merge" "gh secret" "gh auth"
    "gh issue" "gh api" "apko publish"
  ];

  # PreToolUse/Bash guard for the "sandbox" profile. The agent runs every other
  # tool without a prompt. This hook denies any output containing one of the tools.
  sandboxHook = pkgs.writeShellScript "claude-deny" ''
    cmd=$(${pkgs.jq}/bin/jq -r '.tool_input.command // ""')

    # Print a PreToolUse deny decision, then stop.
    deny() {
      ${pkgs.jq}/bin/jq -cn --arg reason "$1" '{
        hookSpecificOutput: {
          hookEventName: "PreToolUse",
          permissionDecision: "deny",
          permissionDecisionReason: $reason
        }
      }'
      exit 0
    }

    lower=''${cmd,,}
    for word in ${lib.escapeShellArgs sandboxBlocked}; do
      if [[ "$lower" == *"$word"* ]]; then
        deny "This machine denies use of tool \"$word\". Continue without this tool or ask the human to run it."
      fi
    done

    exit 0
  '';

  # Read-only commands that the "workstation" profile runs without a prompt.
  # A name here must not write a file, delete data, send local data off the
  # machine, or run a command that it receives as an argument.
  allowTools = [
    "cd" "ls" "tree" "pwd" "stat" "file" "du" "df" "realpath" "readlink" "basename" "dirname" "lsblk" "mountpoint"
    "cat" "head" "tail" "nl" "tac" "rev" "wc" "grep" "egrep" "fgrep" "rg" "cut" "tr" "uniq" "comm" "join" "rg"
    "paste" "column" "fold" "expand" "unexpand" "diff" "cmp" "diff3" "md5sum" "sha1sum" "sha256sum" "sha512sum"
    "b2sum" "cksum" "base64" "xxd" "hexdump" "od" "strings" "jq" "yq" "uname" "hostname" "whoami" "id" "groups"
    "printenv" "locale" "date" "cal" "uptime" "free" "nproc" "lscpu" "lsusb" "lspci" "ps" "pgrep" "pstree" "lsof"
    "vmstat" "iostat" "journalctl" "which" "type" "whereis" "command -v" "compgen" "alias" "echo" "printf" "seq"
    "true" "false" "test" "dig" "nslookup" "host" "whois" "ip addr" "ip route" "ip link" "ss" "netstat" "arp"
    "go version" "go env" "go doc" "go list" "go vet" "go build" "go test" "go mod graph" "go mod why"
    "go mod verify" "gofmt -l" "gofmt -d" "golangci-lint" "staticcheck" "govulncheck" "crane digest"
    "crane manifest" "crane config" "crane ls" "crane catalog" "skopeo inspect" "cosign verify" "cosign tree"
    "cosign triangulate" "syft" "grype" "trivy" "gh pr view" "gh pr list" "gh pr diff" "gh pr checks"
    "gh pr status" "gh issue view" "gh issue list" "gh run view" "gh run list" "gh repo view"
    "gh release list" "gh release view" "gh workflow list" "gh workflow view" "gh search"
    "gh label list" "gh status"
  ];

  # One instruction for each line of ~/.claude/CLAUDE.md. The "sandbox" profile
  # adds a last line.
  claudeInstructions = [
    "Read all links you are given"
    "Prioritize allow list tools to avoid prompting user"
    "Follow settings.json permissions; ask when it is silent"
    "Show your work and explain why"
    "Go packages: interface, implementing struct, mock, and tests for every method"
    "Tests: one unit test per function, table-driven, compare whole objects, cmp.Diff for structs"
    "READMEs: one sentence per line"
    "Write docs in ASD-STE100; be concise but complete"
    "Code comments should be as short as possible"
  ] ++ lib.optional (cfg.profile == "sandbox")
    "Local files are disposable; change them freely. Never change remote state: cloud resources, clusters, registries, git remotes, or issue trackers";

  # Status line script: model, context usage, session cost, water estimate.
  statuslineScript = pkgs.writeShellScript "claude-statusline" ''
    # Claude Code status line: model, context usage, session cost, water estimate
    # Pricing: https://www.anthropic.com/pricing (USD per million tokens)

    input=$(cat)

    model=$(${pkgs.jq}/bin/jq -r '.model.display_name // "unknown"' <<<"$input")
    model_id=$(${pkgs.jq}/bin/jq -r '.model.id // ""' <<<"$input")
    used_pct=$(${pkgs.jq}/bin/jq -r '.context_window.used_percentage // empty' <<<"$input")
    total_in=$(${pkgs.jq}/bin/jq -r '.context_window.total_input_tokens // 0' <<<"$input")
    total_out=$(${pkgs.jq}/bin/jq -r '.context_window.total_output_tokens // 0' <<<"$input")
    authoritative_cost=$(${pkgs.jq}/bin/jq -r '.cost.total_cost_usd // empty' <<<"$input")

    # An empty .cost.total_cost_usd reads as 0 in awk
    read -r cost_raw cost_display < <(${pkgs.gawk}/bin/awk -v c="$authoritative_cost" 'BEGIN{
      if (c < 0.01) printf "%.4f $%.4f\n", c, c
      else printf "%.4f $%.2f\n", c, c }')

    # Water footprint (~170 mL/$, scope 1+2; ±10x uncertainty)
    water=$(${pkgs.gawk}/bin/awk -v c="$cost_raw" 'BEGIN{
      ml = c * 170
      if (ml >= 500)    printf "%.2fbtl", ml/500
      else if (ml >= 1) printf "%.0fmL", ml
      else if (ml > 0)  printf "<1mL"
      else              printf "0mL" }')

    # 8-cell context bar with partial-fill blocks
    make_bar() {
      local pct=$1 cells=8 subs filled full part empty out="" i
      subs=$((cells*8)); filled=$((pct*subs/100))
      (( filled > subs )) && filled=$subs
      (( filled < 0 )) && filled=0
      full=$((filled/8)); part=$((filled%8)); empty=$((cells-full))
      (( part > 0 )) && empty=$((empty-1))
      (( empty < 0 )) && empty=0
      for ((i=0;i<full;i++));  do out+="█"; done
      case $part in 1) out+="▏";; 2) out+="▎";; 3) out+="▍";; 4) out+="▌";;
                    5) out+="▋";; 6) out+="▊";; 7) out+="▉";; esac
      for ((i=0;i<empty;i++)); do out+="░"; done
      printf "%s" "$out"
    }

    parts=("$model")
    if [ -n "$used_pct" ]; then
      used_int=$(printf "%.0f" "$used_pct")
      if   [ "$used_int" -ge 90 ]; then color="\033[91m"
      elif [ "$used_int" -ge 75 ]; then color="\033[33m"
      elif [ "$used_int" -ge 50 ]; then color="\033[36m"
      else                               color="\033[32m"
      fi
      parts+=("$(printf "''${color}$(make_bar "$used_int") ctx:''${used_int}%%\033[0m")")
    fi
    parts+=("$(printf "\033[33mcost:''${cost_display}\033[0m")")
    parts+=("$(printf "\033[94mh2o:''${water}\033[0m")")

    printf "%s" "''${parts[0]}"
    for p in "''${parts[@]:1}"; do printf " | %s" "$p"; done
    printf "\n"
  '';

  # Settings that both profiles share. builtins.toJSON serializes this below,
  # thus Nix checks the structure and there are no commas to keep in order.
  # A profile attribute set layers on top with lib.recursiveUpdate.
  baseSettings = {
    model = "claude-opus-5[1m]";

    # /effort writes this key. Do not set CLAUDE_CODE_EFFORT_LEVEL: the
    # environment variable overrides the session and makes /effort a no-op.
    effortLevel = defaultEffort;

    statusLine = {
      type = "command";
      command = "${statuslineScript}";
    };

    env = {
      SHELL = "${pkgs.zsh}/bin/zsh";
      CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC = "1";
      DISABLE_TELEMETRY = "1";
      DISABLE_ERROR_REPORTING = "1";
      DISABLE_AUTOUPDATER = "1";
      BASH_DEFAULT_TIMEOUT_MS = "600000";
      BASH_MAX_OUTPUT_LENGTH = "200000";
      MCP_TIMEOUT = "30000";
    };

    hooks = {
      PostToolUse = [
        {
          matcher = "Write|Edit";
          hooks = [
            {
              # run gofmt on go files
              type = "command";
              command = "f=$(${pkgs.jq}/bin/jq -r '.tool_input.file_path'); case \"$f\" in *.go) ${pkgs.go}/bin/gofmt -w \"$f\" 2>/dev/null || true ;; esac";
              async = true;
            }
            {
              # run terraform fmt on tf files
              type = "command";
              command = "f=$(${pkgs.jq}/bin/jq -r '.tool_input.file_path'); case \"$f\" in *.tf|*.tfvars) ${pkgs.terraform}/bin/terraform fmt \"$f\" 2>/dev/null || true ;; esac";
              async = true;
            }
          ];
        }
      ];
      UserPromptSubmit = [
        {
          hooks = [
            {
              # always add git diff to context
              type = "command";
              command = "${pkgs.git}/bin/git diff --stat 2>/dev/null || true";
              statusMessage = "Checking git status...";
            }
          ];
        }
      ];
    };

    respectGitignore = true;
    includeCoAuthoredBy = false;
    cleanupPeriodDays = 14;
    alwaysThinkingEnabled = true;
    autoCompactWindow = 700000;
    awaySummaryEnabled = true;
    spinnerTipsEnabled = false;
    verbose = false;
  };

  # lib.recursiveUpdate merges an attribute set key by key, but it replaces a
  # list as a whole. Thus a profile that gives an allow, ask, or deny list
  # replaces the base list, and hooks.PreToolUse from sandboxPermissions joins
  # the PostToolUse and UserPromptSubmit hooks above.
  settings =
    if cfg.profile == "sandbox"
    then lib.recursiveUpdate baseSettings sandboxPermissions
    else lib.recursiveUpdate baseSettings restrictedPermissions;
in
{
  options.my.claude = {
    profile = lib.mkOption {
      type = lib.types.enum [ "workstation" "sandbox" ];
      default = "workstation";
      description = ''
        Permission posture for Claude Code on this device.

        "workstation" asks before a mutating action, and is correct for a
        machine that holds work you cannot replace.

        "sandbox" has different restrictions for a disposable VM.
      '';
    };
  };

  config = {
    home.packages = with pkgs; [
      claude-code
    ];

    # config file
    home.file.claude_settings = {
      enable = true;
      target = "${claudeDir}/settings.json";
      text = builtins.toJSON settings;
    };

    # claude md main file
    home.file.claude = {
      enable = true;
      target = "${claudeDir}/CLAUDE.md";
      text = lib.concatStringsSep "\n" claudeInstructions + "\n";
    };
  };
}
