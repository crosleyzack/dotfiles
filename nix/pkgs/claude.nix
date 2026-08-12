{ config, pkgs, ... }:

let
  # Default reasoning effort for Claude Code sessions started with no flag.
  # Override for a single session with `claude --effort <low|medium|high|xhigh|max>`
  # (or `claude -c --effort <level>` to resume the current conversation at that level).
  # The CLI flag takes precedence over this env var and writes nothing back to
  # settings.json, so per-task overrides never mutate this shared default.
  defaultEffort = "high";
in
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
    "model": "claude-opus-4-8[1m]",
    "statusLine": {
        "type": "command",
        "command": "bash ${config.home.homeDirectory}/.claude/statusline-command.sh"
    },
    "env": {
        "SHELL": "${pkgs.zsh}/bin/zsh",
        "CLAUDE_CODE_EFFORT_LEVEL": "${defaultEffort}",
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
            "Bash(head *)",
            "Bash(tail *)",
            "Bash(find *)",
            "Bash(git diff *)",
            "Bash(git log *)",
            "Bash(git status *)",
            "Bash(go test *)",
            "Bash(go doc *)",
            "Bash(go build *)",
            "Bash(golangci-lint *)",
            "Bash(terraform plan *)",
            "Bash(terraform show *)",
            "Bash(terraform validate *)",
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
            "Read(${config.home.homeDirectory}/**)",
            "Read(/tmp/claude*/**)"
        ], 
        "ask": [
            "Edit(${config.home.homeDirectory}/**)",
            "Edit(/tmp/claude*/**)",
            "WebFetch",
            "WebSearch",
            "Bash(terraform apply *)",
            "Bash(terraform import *)",
            "Bash(terraform taint *)",
            "Bash(terraform state mv *)",
            "Bash(gcloud * create *)",
            "Bash(gcloud * update *)",
            "Bash(gcloud * deploy *)",
            "Bash(gcloud run deploy *)",
            "Bash(kubectl apply *)",
            "Bash(kubectl create *)",
            "Bash(kubectl delete *)",
            "Bash(kubectl edit *)",
            "Bash(kubectl patch *)",
            "Bash(kubectl scale *)",
            "Bash(kubectl rollout restart *)",
            "Bash(kubectl exec *)",
            "Bash(kubectl port-forward *)",
            "Bash(docker rm *)",
            "Bash(docker rmi *)",
            "Bash(docker kill *)",
            "Bash(docker stop *)",
            "Bash(docker exec *)",
            "Bash(aws * put-* *)",
            "Bash(aws * create-* *)",
            "Bash(aws * update-* *)",
            "Bash(aws * modify-* *)",
            "Bash(aws * stop-* *)",
            "Bash(npm install *)",
            "Bash(npm ci *)",
            "Bash(yarn install *)",
            "Bash(pnpm install *)",
            "Bash(npm publish *)",
            "Bash(pip install *)",
            "Bash(go get *)",
            "Bash(go install *)",
            "Bash(helm install *)",
            "Bash(helm upgrade *)",
            "Bash(ansible-playbook *)",
            "Bash(git add *)",
            "Bash(git commit *)",
            "Bash(git push *)",
            "Bash(git pull *)",
            "Bash(git merge *)",
            "Bash(git rebase *)",
            "Bash(git cherry-pick *)"
        ],
        "deny": [
            "Read(*.pem)",
            "Read(credentials*)",
            "Read(secrets/*)",
            "Read(**/.env)",
            "Read(**/.env.*)",
            "Read(**/*password*)",
            "Read(**/*secret*)",
            "Read(**/*token*)",
            "Read(${config.home.homeDirectory}/.ssh/**)",
            "Read(id_rsa*)",
            "Read(id_dsa*)",
            "Read(id_ecdsa*)",
            "Read(id_ed25519*)",
            "Read(*.ppk)",
            "Read(authorized_keys)",
            "Read(known_hosts)",
            "Read(*.keystore)",
            "Read(*.jks)",
            "Read(*.p12)",
            "Read(*.pfx)",
            "Read(*.ovpn)",
            "Read(${config.home.homeDirectory}/.aws/**)",
            "Read(${config.home.homeDirectory}/.config/gcloud/**)",
            "Read(${config.home.homeDirectory}/.azure/**)",
            "Read(${config.home.homeDirectory}/.kube/config)",
            "Read(${config.home.homeDirectory}/.docker/config.json)",
            "Read(${config.home.homeDirectory}/.gnupg/**)",
            "Read(${config.home.homeDirectory}/.password-store/**)",
            "Edit(*.pem)",
            "Edit(*.key)",
            "Edit(id_rsa*)",
            "Edit(package-lock.json)",
            "Edit(**/.env)",
            "Edit(**/.env.*)",
            "Edit(**/*password*)",
            "Edit(**/*secret*)",
            "Edit(**/*token*)",
            "Edit(${config.home.homeDirectory}/.ssh/**)",
            "Edit(*.keystore)",
            "Edit(*.jks)",
            "Edit(*.p12)",
            "Edit(*.pfx)",
            "Edit(${config.home.homeDirectory}/.aws/**)",
            "Edit(${config.home.homeDirectory}/.config/gcloud/**)",
            "Edit(${config.home.homeDirectory}/.kube/config)",
            "Edit(${config.home.homeDirectory}/.gnupg/**)",
            "Edit(${config.home.homeDirectory}/.password-store/**)",
            "Bash(* rm -rf *)",
            "Bash(* git push --force *)",
            "Bash(* git yolo *)",
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
            "Bash(* >/dev/sd *)",
            "Bash(* curl * | bash *)",
            "Bash(* wget * | bash *)",
            "Bash(* curl * | sh *)",
            "Bash(* wget * | sh *)",
            "Bash(* eval *)",
            "Bash(* exec *)",
            "Bash(* systemctl *)",
            "Bash(* useradd *)",
            "Bash(* usermod *)",
            "Bash(* userdel *)",
            "Bash(* mount *)",
            "Bash(* umount *)",
            "Bash(* iptables *)",
            "Bash(* ufw *)",
            "Bash(* chown -R *)",
            "Bash(* docker run --privileged *)",
            "Bash(* insmod *)",
            "Bash(* rmmod *)",
            "Bash(* modprobe *)",
            "Bash(* pkexec *)",
            "Bash(* doas *)",
            "Bash(* terraform destroy *)",
            "Bash(* terraform state rm *)",
            "Bash(* terraform force-unlock *)",
            "Bash(* terraform workspace delete *)",
            "Bash(* gcloud * delete *)",
            "Bash(* gcloud projects delete *)",
            "Bash(* gcloud sql instances delete *)",
            "Bash(* gcloud container clusters delete *)",
            "Bash(* kubectl delete namespace *)",
            "Bash(* kubectl delete pv *)",
            "Bash(* kubectl delete pvc *)",
            "Bash(* kubectl drain *)",
            "Bash(* docker system prune *)",
            "Bash(* docker volume prune *)",
            "Bash(* docker network prune *)",
            "Bash(* aws * delete-* *)",
            "Bash(* aws * terminate-* *)",
            "Bash(* aws rds delete-* *)",
            "Bash(* aws s3 rm * --recursive *)",
            "Bash(* aws s3api delete-* *)",
            "Bash(* helm uninstall *)",
            "Bash(* helm delete *)",
            "Bash(* kind delete cluster *)",
            "Bash(* k3d cluster delete *)",
            "Bash(* vagrant destroy *)",
            "Bash(* npm unpublish *)"
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
    # claude md main file
    home.file.claude = {
        enable = true;
        target = ".claude/CLAUDE.md";
        text = ''
Read all links you are given
Use permissions in settings.json; ask for permission if settings.json doesn't give it to you
Always show you work and explain why you are doing this
Go packages should always have an interface, a struct implementing that interface, a mock of the interface, and comprehensive tests for every method
Function test should use table-driven pattern and compare the full output object to the expected output object; use cmp.Diff for structs
Go tests should use stretch/testify for comparisons
README files should have newlines between sentences
Write all documentation using ASD-STE100. Be concise but detailed.
        '';
    };
    home.file.claude_status = {
        enable = true;
        target = "${config.home.homeDirectory}/.claude/statusline-command.sh";
        executable = true;
        text = ''
#!/usr/bin/env bash
# Claude Code status line: model, context usage, session cost, water estimate
# Pricing: https://www.anthropic.com/pricing (USD per million tokens)

input=$(cat)

model=$(jq -r '.model.display_name // "unknown"' <<<"$input")
model_id=$(jq -r '.model.id // ""' <<<"$input")
used_pct=$(jq -r '.context_window.used_percentage // empty' <<<"$input")
total_in=$(jq -r '.context_window.total_input_tokens // 0' <<<"$input")
total_out=$(jq -r '.context_window.total_output_tokens // 0' <<<"$input")
authoritative_cost=$(jq -r '.cost.total_cost_usd // empty' <<<"$input")

# Per-MTok input/output pricing by model family
case "$model_id" in
  *opus*)   cost_in=5.00;  cost_out=25.00 ;;
  *haiku*)  cost_in=1.00;  cost_out=5.00  ;;
  *)        cost_in=3.00;  cost_out=15.00 ;;  # sonnet default
esac

# Prefer authoritative .cost.total_cost_usd; fall back to token estimate
if [ -n "$authoritative_cost" ]; then
  read -r cost_raw cost_display < <(awk -v c="$authoritative_cost" 'BEGIN{
    if (c < 0.01) printf "%.4f $%.4f\n", c, c
    else printf "%.4f $%.2f\n", c, c }')
else
  read -r cost_raw cost_display < <(awk -v i="$total_in" -v o="$total_out" \
    -v ci="$cost_in" -v co="$cost_out" 'BEGIN{
      c = (i/1e6)*ci + (o/1e6)*co
      if (c < 0.01) printf "%.4f $%.4f\n", c, c
      else printf "%.4f $%.2f\n", c, c }')
fi

# Water footprint (~170 mL/$, scope 1+2; ±10x uncertainty)
water=$(awk -v c="$cost_raw" 'BEGIN{
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
    };
}
