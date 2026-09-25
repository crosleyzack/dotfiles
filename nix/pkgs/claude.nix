{ config, pkgs, lib, ... }:

let
  cfg = config.my.claude;

  # Override for a single session with `claude --effort <low|medium|high|xhigh|max>`
  # (or `claude -c --effort <level>` to resume the current conversation at that level).
  defaultEffort = "high";

  claudeDir = "${config.home.homeDirectory}/.claude";

  # ── Extensions ──────────────────────────────────────────────────────────────
  # A name here installs the plugin and turns it on. The "/plugin" menu cannot:
  # it writes to settings.json, and that file is a read-only link to the store.
  #
  # An LSP plugin installs no binary. gopls comes from go.nix.
  #
  # A plugin also carries the only MCP server a Nix file can declare, because
  # settings.json holds no "mcpServers" key.
  marketplace = "claude-plugins-official";

  plugins = [
    "gopls-lsp"
    "linear"
  ];

  # The list above holds only a plugin whose files sit in the marketplace. For
  # the rest, a folder here loads as "<name>@skills-dir": no install step, and
  # no write to the read-only settings file. It needs a plugin.json.
  skillPlugins = {
    mattpocock-skills = pkgs.fetchFromGitHub {
      owner = "mattpocock";
      repo = "skills";
      rev = "959a8e9f1edc3adbe2f7e3054bb6fbefa6696260"; # v1.2.3
      hash = "sha256-AbIlPEE0VWJq+NJpa56SDzhM8o7vXDBtlJHS5FCTElE=";
    };
  };

  # ── Derived permissions ─────────────────────────────────────────────────────
  # One policy makes both profiles: the "tools" set below. Every tool holds four
  # lists of words, and each list gives one outcome for each machine.
  #
  #                read    writeLocal   writeRemote   deny
  #     sandbox    allow   allow        deny          deny
  #     host       allow   ask          ask           deny
  #
  # No human watches the sandbox, thus a prompt there stops the agent with no
  # answer. A remote write becomes a denial for that reason alone. A local write
  # still passes, because that machine holds no work that a person cannot
  # replace.
  #
  # The hook makes every denial, and the rules below make the rest. A rule holds
  # the reads of both machines and the local writes of the sandbox. Every other
  # command reaches no rule, and the default mode of the workstation asks.
  profilePermissions = profile:
    let sandbox = profile == "sandbox"; in
    {
      permissions = {
        # Lock both machines out of bypassPermissions mode. That mode skips the
        # rules below, and the hook is the only check that stays.
        disableBypassPermissionsMode = "disable";
        defaultMode = if sandbox then "acceptEdits" else "default";

        allow = [
          "Bash(* --version)"
          "Bash(* --help)"
        ]
        ++ lib.concatMap (tool: [
          "Bash(${tool} *)"
          "Bash(* ${tool} *)"
        ]) allowTools
        ++ readRules
        # A rule of one name and no path holds for every path.
        ++ lib.optionals sandbox ([
          "Read"
          "Glob"
          "Grep"
          "Edit"
          "Write"
          "NotebookEdit"
          "WebFetch"
          "WebSearch"
        ] ++ writeLocalRules)
        ++ lib.optionals (!sandbox) [
          "Read(${config.home.homeDirectory}/**)"
          "Read(/tmp/claude*/**)"
        ];

        # A write word needs no rule here: the default mode of the workstation
        # asks for every command that no allow rule holds. Thus only the file
        # paths and the web tools need a line.
        ask = lib.optionals (!sandbox) [
          "Edit(${config.home.homeDirectory}/**)"
          "Edit(/tmp/claude*/**)"
          "WebFetch"
          "WebSearch"
        ];

        deny = blockedCommandRules ++ extraDenyRules;
      };

      hooks.PreToolUse = [
        {
          matcher = "Bash";
          hooks = [
            {
              type = "command";
              command = "${gateHook profile}";
            }
          ];
        }
      ];
    };

  # Two rules for each command: one for the start of the command line, one for a
  # later position, such as after a pipe or inside a subshell.
  blockedCommandRules = lib.concatMap (command: [
    "Bash(${command} *)"
    "Bash(* ${command} *)"
  ]) blockedCommands;

  # A name from blockedCommands holds no entry in the "tools" set, thus this
  # filter drops nothing today. It keeps the two lists consistent: a name that
  # joins both must block, and not gate.
  gatedTools = lib.filterAttrs (name: _: !(lib.elem name blockedCommands)) tools;

  # The words that the hook denies. No human watches the sandbox, thus a remote
  # write stops there with the deny words. The workstation asks for a remote
  # write instead, and its default mode holds that prompt.
  denyWords = profile: v:
    (v.deny or [ ]) ++ lib.optionals (profile == "sandbox") (v.writeRemote or [ ]);

  # The words that the sandbox runs with no prompt.
  passWords = v: (v.read or [ ]) ++ (v.writeLocal or [ ]);

  # The hook denies a command of a strict tool that holds no word of its own. It
  # stays quiet on the workstation, where the prompt of the profile answers for
  # an unknown word. In the sandbox that prompt has nobody to answer it.
  isStrict = profile: _: profile == "sandbox";

  # Four rules for each verb. The verb comes straight after the tool in "gcloud
  # info", and after a resource group in "gcloud compute instances list". Each
  # of the two positions needs a form with arguments and a form without.
  verbRules = tool: verb: [
    "Bash(${tool} ${verb})"
    "Bash(${tool} ${verb} *)"
    "Bash(${tool} * ${verb})"
    "Bash(${tool} * ${verb} *)"
  ];

  # A rule holds the whole command as one string, and it cannot hold the order
  # of the words. Thus a tool with "argumentVerbs" gets no rule at all, and the
  # hook alone judges it. Every command of such a tool waits for a human.
  ruleTools = lib.filterAttrs (_: v: !(v.argumentVerbs or false)) gatedTools;

  # Both profiles allow every read. No rule here starts with "*": such a rule
  # also matches "<write> && <read>", and a prompt is the correct stop for that
  # command. The hook cuts a command apart and tests every piece, thus it stops
  # the write in any case.
  readRules = lib.concatLists (lib.mapAttrsToList
    (name: v: lib.concatMap (verbRules name) (v.read or [ ]))
    ruleTools);

  # The sandbox alone reads this list, thus the name of the profile is fixed
  # here. A local write costs that machine nothing, and the workstation keeps
  # its prompt for the same word.
  writeLocalRules = lib.concatLists (lib.mapAttrsToList
    (name: v: lib.concatMap (verbRules name) (v.writeLocal or [ ]))
    ruleTools);

  # Denials that the "tools" set cannot express, for both profiles.
  extraDenyRules = [
    # dangerous commands
    "Bash(* rm -rf *)"
    "Bash(* git push --force *)"
    "Bash(* git reset --hard *)"
    "Bash(* chmod 777 *)"
    "Bash(* chown -R *)"
    "Bash(* >/dev/sd *)"
    "Bash(* curl * | bash *)"
    "Bash(* wget * | bash *)"
    "Bash(* curl * | sh *)"
    "Bash(* wget * | sh *)"
    "Bash(* eval *)"
    "Bash(* exec *)"
    "Bash(* docker run --privileged *)"
    "Bash(* aws s3 rm * --recursive *)"
    # secrets files
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
    "Read(${config.home.homeDirectory}/.config/gh/**)"
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
    "Edit(${config.home.homeDirectory}/.config/gh/**)"
    "Edit(${config.home.homeDirectory}/.kube/config)"
    "Edit(${config.home.homeDirectory}/.gnupg/**)"
    "Edit(${config.home.homeDirectory}/.password-store/**)"
  ];

  # Commands with no safe operation for an agent, and no verb worth a test. Both
  # profiles block these, thus they carry no entry in the "tools" set below.
  blockedCommands = [
    "sudo" "su" "doas" "pkexec" "ssh" "nc" "netcat" "socat" "nmap" "masscan"
    "passwd" "chpasswd" "mkfs" "fdisk" "parted" "dd" "crontab" "kill" "killall"
    "systemctl" "useradd" "usermod" "userdel" "mount" "umount" "iptables"
    "ufw" "insmod" "rmmod" "modprobe" "ansible-playbook"
    "pg_dump" "pg_dumpall" "pg_restore" "mysqldump" "mysqlimport"
    "cloud-sql-proxy" "cloud_sql_proxy"
  ];

  # ── Tool policy ─────────────────────────────────────────────────────────────
  # One entry for each tool that a profile limits by verb. A tool that no
  # profile allows at all belongs in blockedCommands above, not here. Both the
  # permission rules above and the hook below come from this set.
  #
  #   read        Words that only read.
  #   writeLocal  Words that change this machine alone. A download belongs here:
  #               "git fetch" and "npm install" read a remote and write a file.
  #   writeRemote Words that change state off this machine.
  #   deny        Words that lose data, as "terraform destroy" and "psql drop"
  #               do. A backup is the only way back from one of these.
  #   flags       Flags that make a read command a write, as "-X" does for
  #               "gh api". Both profiles deny these, because an allow rule
  #               already holds the read verb of the command.
  #
  # A word that hands out a credential or that runs a command of its own sits in
  # writeRemote, and not in writeLocal. "git config" is the example: it names a
  # pager, and a later "git log" runs that pager. The hook sees the words of
  # "git log" alone, thus a human decides that one.
  #
  # The lists are per tool because one word has two meanings across tools:
  # "export" reads an image for crane but writes a bucket for gcloud, "config"
  # reads for crane but writes for gh, and "kill" ends a process for docker but
  # a Dataflow job for gcloud. A pattern matches one whole word, thus "get-*"
  # matches "get-iam-policy" but not "widget-x".
  tools = {
    gcloud = {
      read = [
        "list" "list-*" "describe" "get" "get-*" "read" "info" "version"
        "status" "ls" "cat" "tail"
      ];
      writeRemote = [
        "create" "create-*" "undelete" "add" "add-*" "remove" "remove-*"
        "update" "update-*" "patch" "set" "set-*" "unset" "deploy" "submit"
        "import" "export" "apply" "call" "invoke" "login" "logout" "revoke"
        "enable" "disable" "attach" "detach" "start" "stop" "restart" "reset"
        "resize" "rollback" "promote" "migrate" "move" "mv" "rm" "cp" "rsync"
        "scp" "sftp" "ssh" "connect" "print-*" "activate" "impersonate*"
        "kill" "abandon" "drain" "rotate" "sign*" "decrypt" "encrypt"
      ];
      deny = [ "delete" "delete-*" ];
    };
    terraform = {
      read = [
        "plan" "show" "validate" "output" "graph" "providers" "state" "list"
        "pull" "fmt" "init" "version" "get"
      ];
      writeRemote = [
        "apply" "import" "taint" "untaint" "refresh" "mv" "push"
        "replace-provider" "lock" "unlock" "login" "logout" "new" "select"
        "test"
      ];
      # "terraform state rm" holds a read word and a deny word. The hook tests
      # the deny list first, thus the command stops.
      deny = [ "destroy" "rm" "force-unlock" "delete" ];
      # "terraform init -migrate-state" moves state to a new backend. The verb
      # reads, thus the verb check alone is not enough. Each pattern starts
      # with "*" to accept one dash or two.
      flags = [ "*-migrate-state" "*-force-copy" "*-auto-approve" ];
    };
    gh = {
      # "api" sends GET until a flag makes it something else, thus it reads
      # here and the flag list below holds the rest.
      read = [
        "api" "view" "list" "status" "checks" "diff" "search" "read-*"
        "checkout" "download" "verify*" "watch" "check" "item-list"
        "field-list"
      ];
      # The first lines are verbs. The rest are whole namespaces that run
      # code, move credentials, or start remote compute: no verb of theirs is
      # a read. "run" is absent on purpose, so that "gh run list" passes;
      # "workflow" covers "gh workflow run".
      writeRemote = [
        "create" "create-*" "close" "reopen" "edit" "comment" "merge" "review"
        "ready" "revert" "transfer" "develop" "pin" "unpin" "lock" "unlock"
        "rename" "archive" "unarchive" "fork" "sync" "upload" "rerun" "cancel"
        "enable" "disable" "install" "uninstall" "update" "publish" "set"
        "set-*" "add" "remove" "import" "link" "unlink" "copy" "clone"
        "mark-template" "restore" "item-add" "item-archive" "item-create"
        "item-delete" "item-edit" "field-create" "field-delete"
        "auth" "alias" "extension" "ext" "copilot" "config" "skill" "secret"
        "variable" "gpg-key" "ssh-key" "deploy-key" "codespace" "cs"
        "agent-task" "gist" "workflow"
      ];
      deny = [ "delete" "delete-*" ];
      # "-x" and "--method" name another method than GET. A field flag changes
      # the method to POST on its own. Lower case hides the difference between
      # "-f" and "-F", and both are field flags.
      flags = [ "-x*" "*-method*" "-f*" "*-field*" "*-input*" ];
    };
    crane = {
      read = [
        "digest" "manifest" "config" "ls" "catalog" "validate" "version"
        "pull" "export" "blob" "layout"
      ];
      writeRemote = [
        "push" "copy" "cp" "tag" "append" "mutate" "rebase" "flatten" "index"
        "optimize" "edit" "registry" "auth" "login" "logout"
      ];
      deny = [ "delete" ];
    };
    apko = {
      read = [ "build" "show-*" "dot" "lock" "version" ];
      writeRemote = [ "publish" ];
    };
    kubectl = {
      read = [
        "get" "describe" "logs" "top" "explain" "api-resources"
        "api-versions" "version" "cluster-info" "view" "can-i" "diff"
      ];
      writeRemote = [
        "apply" "create" "edit" "patch" "replace" "scale" "autoscale"
        "rollout" "exec" "attach" "port-forward" "proxy" "cp" "label"
        "annotate" "set" "set-*" "expose" "run" "taint" "cordon" "uncordon"
        "certificate" "config"
      ];
      deny = [ "delete" "drain" "evict" ];
    };
    aws = {
      read = [ "describe-*" "list-*" "get-*" "head-*" "ls" "version" ];
      writeRemote = [
        "create-*" "update-*" "modify-*" "put-*" "post-*" "start-*" "stop-*"
        "reboot-*" "run-*" "invoke*" "attach-*" "detach-*" "associate-*"
        "disassociate-*" "register-*" "deregister-*" "tag-*" "untag-*"
        "enable-*" "disable-*" "import-*" "export-*" "restore-*" "copy-*"
        "cancel-*" "reset-*" "add-*" "remove-*" "replace-*" "send-*"
        "publish*" "cp" "mv" "sync" "configure" "login" "logout"
      ];
      deny = [ "delete-*" "terminate-*" "purge-*" "rm" ];
    };
    helm = {
      read = [
        "list" "get" "status" "show" "history" "version" "template" "lint"
        "search" "pull" "verify"
      ];
      writeRemote = [
        "install" "upgrade" "rollback" "add" "update" "push" "package"
        "create" "registry" "login" "logout"
      ];
      deny = [ "uninstall" "delete" "reset" ];
    };

    # A cluster of k3d, kind, or vagrant lives on this machine, thus the words
    # that make one are local. The words that destroy one lose the state of
    # every container in it.
    k3d = {
      read = [ "list" "get" "version" ];
      writeLocal = [ "create" "start" "stop" "import" ];
      deny = [ "delete" ];
    };
    kind = {
      read = [ "get" "version" "export" ];
      writeLocal = [ "create" "load" ];
      deny = [ "delete" ];
    };
    vagrant = {
      read = [ "status" "version" "ssh-config" "validate" ];
      writeLocal = [ "up" "halt" "reload" "provision" "suspend" ];
      deny = [ "destroy" ];
    };

    # A hardware key is no part of this machine, thus every word that changes
    # one waits for a human. "code" prints a one-time password, thus it hands
    # out a credential. "reset" wipes the key, and no backup brings it back.
    ykman = {
      read = [ "list" "info" "export" "view" ];
      writeRemote = [
        "generate" "import" "delete" "add" "set-*" "change-*" "unblock"
        "access" "config" "enable" "disable" "rename" "code" "static"
        "chalresp" "calculate" "keygen" "write" "attest" "mode"
      ];
      deny = [ "reset" ];
    };

    # A database client takes its operation as an argument, and the hook cuts a
    # command into words. Thus "psql -c \"select 1\"" shows the word "select",
    # and the same lists hold for these tools too. A client with no operation
    # opens a session that runs anything, thus it finds no read word and stops.
    #
    # "drop" and "truncate" lose a table. Every other word changes rows, and a
    # human answers for those.
    #
    # "argumentVerbs" stops the rule generator for these three tools. SQL puts
    # one statement inside another, thus a read word appears in a write:
    # "insert into t values (1)" holds "values", and "insert into t select ..."
    # holds "select". A rule of "psql * select *" would allow both. The hook
    # tests the deny words first, thus it reads such a command correctly.
    psql = {
      argumentVerbs = true;
      read = [ "select" "show" "explain" "with" "table" "values" ];
      writeRemote = [
        "insert" "update" "delete" "alter" "create" "grant" "revoke" "copy"
        "merge" "call" "do" "vacuum" "reindex" "cluster" "refresh" "lock"
        "comment" "begin" "commit" "rollback" "set" "reset" "analyze"
      ];
      deny = [ "drop" "truncate" ];
    };
    mysql = {
      argumentVerbs = true;
      read = [ "select" "show" "explain" "describe" "desc" "with" "table" ];
      writeRemote = [
        "insert" "update" "delete" "alter" "create" "grant" "revoke"
        "replace" "load" "call" "set" "lock" "unlock" "flush" "rename"
        "optimize" "repair" "analyze" "start" "commit" "rollback" "source"
      ];
      deny = [ "drop" "truncate" "shutdown" ];
    };
    redis-cli = {
      argumentVerbs = true;
      read = [
        "get" "mget" "keys" "scan" "exists" "ttl" "type" "info" "dbsize"
        "llen" "lrange" "lindex" "smembers" "sismember" "scard" "hget"
        "hgetall" "hkeys" "hlen" "zrange" "zcard" "zscore" "strlen"
        "getrange" "object" "memory" "ping" "command" "latency" "slowlog"
      ];
      # "select" switches database here, and reads data for psql. One word
      # with two meanings is the reason each tool keeps its own lists.
      writeRemote = [
        "set" "setex" "setnx" "mset" "getset" "append" "del" "unlink"
        "expire" "persist" "rename" "lpush" "rpush" "lpop" "rpop" "sadd"
        "srem" "hset" "hdel" "zadd" "zrem" "incr" "decr" "incrby" "decrby"
        "eval" "evalsha" "script" "config" "save" "bgsave" "bgrewriteaof"
        "slaveof" "replicaof" "migrate" "restore" "debug" "client" "cluster"
        "acl" "swapdb" "select"
      ];
      deny = [ "flushall" "flushdb" "shutdown" ];
    };

    # Every tool below holds a writeLocal list: it changes this machine, and it
    # reaches a remote with a few words alone.
    git = {
      read = [
        "status" "diff" "log" "show" "blame" "ls-files" "ls-remote"
        "rev-parse" "describe" "shortlog" "reflog" "cat-file" "grep"
        "patch-id"
      ];
      writeLocal = [
        "add" "commit" "stash" "checkout" "switch" "restore" "tag" "branch"
        "init" "clone" "fetch" "pull" "merge" "rebase" "cherry-pick" "revert"
        "apply" "am" "mv" "rm" "clean" "reset" "remote" "submodule" "bisect"
        "worktree"
      ];
      # "git config core.pager <command>" makes a later "git log" run that
      # command, and the hook sees the words of "git log" alone. Thus it waits
      # for a human, as "gh config" does.
      writeRemote = [ "push" "config" ];
      deny = [ "yolo" ];
    };
    docker = {
      read = [
        "ps" "logs" "inspect" "images" "version" "info" "history" "port"
        "top" "stats" "diff" "search"
      ];
      writeLocal = [
        "run" "build" "start" "stop" "restart" "kill" "exec" "cp" "commit"
        "tag" "save" "load" "create" "update" "rename" "pause" "unpause"
        "rm" "rmi" "compose" "pull" "network" "volume" "image" "container"
      ];
      writeRemote = [ "push" "login" "logout" ];
      # "docker system prune" takes every image and volume of this machine.
      deny = [ "prune" ];
    };
    npm = {
      read = [ "ls" "list" "view" "info" "outdated" "audit" "explain" "why" ];
      writeLocal = [
        "install" "ci" "run" "exec" "update" "uninstall" "link" "init"
        "test" "build" "start" "rebuild" "dedupe" "prune"
      ];
      writeRemote = [
        "publish" "deprecate" "owner" "access" "login" "logout" "token"
      ];
      # A package name stays gone for the users of it.
      deny = [ "unpublish" ];
    };
    yarn = {
      read = [ "list" "info" "why" "outdated" "audit" ];
      writeLocal = [ "install" "add" "remove" "run" "test" "build" "upgrade" ];
      writeRemote = [ "publish" "login" "logout" ];
    };
    pnpm = {
      read = [ "list" "why" "outdated" "audit" ];
      writeLocal = [ "install" "add" "remove" "run" "test" "build" "update" ];
      writeRemote = [ "publish" "login" "logout" ];
    };
    pip = {
      read = [ "list" "show" "freeze" "check" "index" ];
      writeLocal = [ "install" "uninstall" "download" "wheel" ];
    };
    go = {
      # "graph", "why", and "verify" are here for "go mod graph" and its two
      # neighbours: "mod" writes go.mod for "go mod tidy", thus the second
      # word of the command is the one that shows a read.
      read = [
        "version" "env" "doc" "list" "vet" "build" "test" "fmt" "graph"
        "why" "verify"
      ];
      writeLocal = [ "get" "install" "generate" "run" "mod" "work" "clean" ];
    };
    cosign = {
      read = [
        "verify*" "tree" "triangulate" "version" "download" "public-key"
      ];
      writeRemote = [
        "sign" "sign-blob" "attest" "attest-blob" "attach" "upload" "copy"
        "generate-key-pair" "import-key-pair" "initialize" "save" "load"
        "login" "piv-tool"
      ];
      # "cosign clean" takes every signature of an image.
      deny = [ "clean" ];
    };
    skopeo = {
      read = [
        "inspect" "list-tags" "list-repository-tags" "standalone-verify"
        "manifest-digest"
      ];
      writeRemote = [
        "copy" "sync" "login" "logout" "standalone-sign" "layers"
      ];
      deny = [ "delete" ];
    };
  };

  # One shell case arm for each gated tool of the profile, as in:
  #
  #   gh) guard "$tool" 'api view list' 'delete delete-*' '-x* *-method*' '' ;;
  #
  # The second list holds the words that pass, and the third holds the words
  # that stop. Both come from the profile: the sandbox adds writeRemote to the
  # words that stop, and it makes every tool strict.
  #
  # Every list of patterns packs into one shell word, which the guard function
  # splits again with "for pattern in $reads". Thus five parameters carry three
  # lists of any length. The separator holds the indent of the case statement.
  gateArms = profile:
    let
      # One list of patterns as a single shell word. An empty list gives "".
      packed = patterns: lib.escapeShellArg (lib.concatStringsSep " " patterns);

      arm = name: v: lib.concatStringsSep " " [
        "${name}) guard \"$tool\""
        (packed (passWords v))
        (packed (denyWords profile v))
        (packed (v.flags or [ ]))
        (packed (lib.optional (isStrict profile v) "strict"))
        ";;"
      ];
    in
    lib.concatStringsSep "\n      " (lib.mapAttrsToList arm gatedTools);

  # PreToolUse/Bash guard, and the only layer that denies a gated word. A rule
  # matches the command as one string, thus it cannot tell "terraform plan" from
  # "terraform plan && terraform apply", and it cannot see the flags that make
  # "gh api" a write. This hook cuts the command apart and tests every piece.
  #
  # A denial of a "deny" word needs no rule of its own for that reason. Such a
  # rule needs eight patterns for each word, and the whole policy would need
  # more than a thousand of them.
  #
  # The hook stays quiet for a word that a human must answer. The default mode
  # of the workstation asks then, because no allow rule holds that command.
  gateHook = profile: pkgs.writeShellScript "claude-gate-${profile}" ''
    # A loop below splits a command into words. Stop pathname expansion, or a
    # word such as "*" becomes a list of the files in the working directory.
    set -f

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

    # Test one command of a gated tool, and deny it or say nothing. gateArms
    # fills the five parameters from the lists of that tool and the profile.
    # The caller fills the "words" and "flags" arrays from the command.
    #
    # Each parameter with patterns arrives as one shell word. The loops below
    # split it again, thus a list of any length fits one parameter. "set -f"
    # above keeps a pattern such as "*-method*" out of pathname expansion.
    guard() {
      local tool="$1" passes="$2" denies="$3" deny_flags="$4" strict="$5"
      local word pattern pass_word="" deny_word=""

      # A flag denies on both machines. "gh api" holds a read verb, thus an
      # allow rule already passes the command, and a prompt never comes.
      for word in "''${flags[@]}"; do
        for pattern in $deny_flags; do
          if [[ "$word" == $pattern ]]; then
            deny "This machine denies the flag \"$word\" of \"$tool\": it makes the command a write. Ask the human to run it."
          fi
        done
      done

      for word in "''${words[@]}"; do
        for pattern in $denies; do
          [[ "$word" == $pattern ]] && deny_word="$word"
        done
        for pattern in $passes; do
          [[ "$word" == $pattern ]] && pass_word="$word"
        done
      done

      # A deny word wins over a pass word: "terraform state rm" holds both.
      if [[ -n "$deny_word" ]]; then
        deny "This machine denies \"$tool $deny_word\". Ask the human to run it."
      fi
      if [[ -n "$strict" && -z "$pass_word" ]]; then
        deny "This machine runs only these operations of \"$tool\": $passes. No human watches this machine, thus every other operation stops here."
      fi
      # Both tests above end in a denial, thus a quiet return needs this line:
      # the last test leaves a false status behind.
      return 0
    }

    # True when one word of the command is exactly "$1". A test for a substring
    # gives a false match: "copyright" holds "gh".
    names_tool() {
      local needle="$1" word
      shift
      for word in "$@"; do
        [[ "$word" == "$needle" ]] && return 0
      done
      return 1
    }

    # One command for each line. Every operator below starts a new command, thus
    # "terraform plan && terraform apply" gives two commands to test. Lower case
    # makes every word match the lower-case patterns of the policy, and it hides
    # the difference between "-X" and "-x".
    #
    # A nested shell keeps a gated tool in reach: the quote comes off below, and
    # a gated tool matches any word, thus "bash -c 'terraform destroy'" stops
    # here. A blocked command needs the first position, thus "sh -c 'sudo ...'"
    # passes this hook. The deny rules of the profile hold that case, because
    # each one of them also matches a later position.
    lower=''${cmd,,}
    parts=''${lower//&&/$'\n'}
    parts=''${parts//||/$'\n'}
    parts=''${parts//|/$'\n'}
    parts=''${parts//;/$'\n'}
    parts=''${parts//&/$'\n'}
    parts=''${parts//'$('/$'\n'}
    parts=''${parts//')'/$'\n'}
    parts=''${parts//'`'/$'\n'}

    while IFS= read -r part; do
      # A flag is not a verb, thus the two arrays stay apart. The test comes
      # before the quotes come off: a quoted "--help" is the value of another
      # flag, and it must stay out of the flag array.
      words=()
      flags=()
      for word in $part; do
        if [[ "$word" == -* ]]; then
          flags+=("$word")
        else
          # A quoted argument holds the operation of a database client, as in
          # psql -c "select 1". Take the quote off, or no pattern matches.
          word=''${word#[\"\']}
          word=''${word%[\"\']}
          words+=("$word")
        fi
      done
      (( ''${#words[@]} )) || continue

      # Both flags print help and stop the tool before it acts. A test of the
      # whole command text would also match a flag inside the value of another
      # flag, as in: gh pr comment -b "--help". "-h" is absent because lower
      # case makes it the same word as "-H", the header flag of "gh api".
      for word in "''${flags[@]}"; do
        [[ "$word" == --help || "$word" == --version ]] && continue 2
      done

      # A blocked command matches the first word alone. Such a word is also a
      # verb of another tool, as in "docker kill", and the command is dangerous
      # only when it runs.
      for tool in ${lib.escapeShellArgs blockedCommands}; do
        if [[ "''${words[0]}" == "$tool" ]]; then
          deny "This machine denies use of \"$tool\". Continue without it or ask the human to run it."
        fi
      done

      # A gated tool matches any word, and not the first word alone: "xargs
      # gcloud projects delete" names the tool in the second position.
      for tool in ${lib.escapeShellArgs (lib.attrNames gatedTools)}; do
        names_tool "$tool" "''${words[@]}" || continue
        case "$tool" in
          ${gateArms profile}
        esac
      done
    done <<< "$parts"

    exit 0
  '';

  # Commands that read and nothing else. Both profiles run these with no prompt.
  # A name here must not write a file, delete data, send local data off the
  # machine, or run a command that it receives as an argument.
  #
  # A tool from the "tools" set belongs here for no reason: its read list makes
  # the same rules, one verb at a time. Thus "go", "gh", "crane", "cosign", and
  # "skopeo" are absent, and only the tools with no verb to test remain.
  allowTools = [
    "cd" "ls" "tree" "pwd" "stat" "file" "du" "df" "realpath" "readlink" "basename" "dirname" "lsblk" "mountpoint"
    "cat" "head" "tail" "nl" "tac" "rev" "wc" "grep" "egrep" "fgrep" "rg" "cut" "tr" "uniq" "comm" "join" "rg"
    "paste" "column" "fold" "expand" "unexpand" "diff" "cmp" "diff3" "md5sum" "sha1sum" "sha256sum" "sha512sum"
    "b2sum" "cksum" "base64" "xxd" "hexdump" "od" "strings" "jq" "yq" "uname" "hostname" "whoami" "id" "groups"
    "printenv" "locale" "date" "cal" "uptime" "free" "nproc" "lscpu" "lsusb" "lspci" "ps" "pgrep" "pstree" "lsof"
    "vmstat" "iostat" "journalctl" "which" "type" "whereis" "command -v" "compgen" "alias" "echo" "printf" "seq"
    "true" "false" "test" "dig" "nslookup" "host" "whois" "ip addr" "ip route" "ip link" "ss" "netstat" "arp"
    "gofmt -l" "gofmt -d" "golangci-lint" "staticcheck" "govulncheck" "syft" "grype" "trivy"
  ];

  # One instruction for each line of ~/.claude/CLAUDE.md. The "sandbox" profile
  # adds a last line.
  claudeInstructions = [
    "In replies: explain fully — what changed, why, what you ruled out, what's risky. Never compress an explanation. Cut ceremony: no preamble, no closing summary, no restating my request."
    "In code: Avoid premature abstractions, add helper functions only when there is a clear reccurring pattern."
    "In comments: only non-obvious why, never what. Comments should not exceed five lines unless absolutely necessary."
    "In docs and comments: use ASD-STE100, one idea per sentence"
    "In docs: Add a mermaid diagram for multi-component architecture or non-trivial control flow"
    "Go packages: interface, implementing struct, mock, and tests for every method"
    "Tests: one unit test per function, table-driven, compare whole objects, cmp.Diff for structs"
    "Markdown: one sentence per line"
    "Read all links you are given"
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

    # Claude Code adds this marketplace on the first interactive start. The
    # entry holds for a machine that starts with "claude -p" instead.
    extraKnownMarketplaces.${marketplace}.source = {
      source = "github";
      repo = "anthropics/claude-plugins-official";
    };

    enabledPlugins = lib.listToAttrs
      (map (name: lib.nameValuePair "${name}@${marketplace}" true) plugins);

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
  # list as a whole. The profile gives no list that baseSettings also gives,
  # thus hooks.PreToolUse from the profile joins the PostToolUse and
  # UserPromptSubmit hooks above.
  settings = lib.recursiveUpdate baseSettings (profilePermissions cfg.profile);
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

    home.file = {
      # config file
      claude_settings = {
        enable = true;
        target = "${claudeDir}/settings.json";
        text = builtins.toJSON settings;
      };

      # claude md main file
      claude = {
        enable = true;
        target = "${claudeDir}/CLAUDE.md";
        text = lib.concatStringsSep "\n" claudeInstructions + "\n";
      };
    }
    # One link for each skill plugin, straight to its source in the store.
    // lib.mapAttrs'
      (name: src: lib.nameValuePair "claude_skill_${name}" {
        enable = true;
        target = "${claudeDir}/skills/${name}";
        source = src;
      })
      skillPlugins;
  };
}
