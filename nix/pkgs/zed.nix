{ config, pkgs, lib, ... }:

let
  # code.nix declares this option. The fallback keeps zed.nix usable without it.
  dockerPath = lib.attrByPath [ "my" "dev" "containers" "dockerPath" ] "docker" config;

  hostLibs = config.my.dev.zed.vulkanLibs;

  # "github.copilot.enable" in code.nix permits suggestions in these languages only.
  predictionLanguages = [
    "Dockerfile"
    "Go"
    "Make"
    "Python"
    "SQL"
    "Shell Script"
    "TSX"
    "TypeScript"
  ];
in
{
  options.my.dev.zed.vulkanLibs = lib.mkOption {
    type = lib.types.str;
    default = "/usr/lib/x86_64-linux-gnu";
    description = ''
      Directory of the host that holds the Vulkan driver of Mesa.
      Zed draws with Vulkan, and the nix loader reads no /etc/ld.so.cache.
      The driver and every library of it stay invisible without this path.
      The default holds for a Debian machine, of a multiarch directory.
      Override per-device (e.g. "/usr/lib64" on Fedora) in that machine's home.nix.
    '';
  };

  config.programs.zed-editor = {
    enable = true;
    enableMcpIntegration = true;

    # The desktop entry and the shell both run "zeditor", thus one wrapper
    # covers every start of Zed.
    #
    # Zed starts an ACP agent under the shell of SHELL, which the login entry
    # of the host fills with a path of no file. The variable holds the zsh of
    # the terminal setting below, which makes one shell for both.
    #
    # "extraPackages" appends to the PATH, thus the go of the host wins. gopls
    # runs "go" off the PATH, thus this prefix gives it the go of the store.
    package = pkgs.symlinkJoin {
      name = "zed-editor-host-vulkan";
      paths = [ pkgs.zed-editor ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/zeditor \
          --suffix LD_LIBRARY_PATH : ${hostLibs} \
          --prefix PATH : ${lib.makeBinPath [ pkgs.go ]} \
          --set SHELL ${pkgs.zsh}/bin/zsh
      '';
      inherit (pkgs.zed-editor) meta;
    };
    # Nix owns settings.json, as it owns the vscode profile in code.nix.
    mutableUserSettings = false;

    # Go, Python, Rust, TypeScript and Bash support is built in.
    extensions = [
      "dockerfile"
      "make"
      # The extension runs "nil" off the PATH, thus extraPackages holds it.
      "nix"
      "proto"
      "sql"
      "terraform"
    ];

    # Nix owns debug.json, as it owns settings.json.
    mutableUserDebug = false;

    # Zed needs "label" and "adapter". The adapter gives every other field.
    userDebug = [
      {
        label = "Go: debug package of file";
        adapter = "Delve";
        request = "launch";
        mode = "debug";
        program = "$ZED_DIRNAME";
      }
      {
        label = "Go: debug tests of package";
        adapter = "Delve";
        request = "launch";
        mode = "test";
        program = "$ZED_DIRNAME";
      }
      {
        label = "Go: debug test at cursor";
        adapter = "Delve";
        request = "launch";
        mode = "test";
        program = "$ZED_DIRNAME";
        args = [ "-test.run" "$ZED_SYMBOL" ];
      }
      {
        label = "Rust: build and debug binary";
        adapter = "CodeLLDB";
        # Zed reads the path of the binary out of a "cargo build" command.
        # It gives the path, thus the entry needs no "program" field.
        build = {
          command = "cargo";
          args = [ "build" ];
        };
        sourceLanguages = [ "rust" ];
      }
      {
        label = "Rust: build and debug tests";
        adapter = "CodeLLDB";
        build = {
          command = "cargo";
          args = [ "test" "--no-run" ];
        };
        sourceLanguages = [ "rust" ];
      }
    ];

    # Zed reads no shell profile. A tool must be on the PATH of the process.
    extraPackages = with pkgs; [
      delve
      direnv
      go
      gopls
      nil
    ];

    userSettings = {
      # theming
      # Zed holds this theme, thus the list of extensions needs no entry.
      theme = "Ayu Dark";
      buffer_font_family = "Monaspice Ar";
      buffer_font_size = 14.5;
      buffer_font_features.calt = false;
      terminal = {
        font_family = "Monaspice Ar";
        shell.program = "${pkgs.zsh}/bin/zsh";
      };
      # vim bindings
      vim_mode = true;
      relative_line_numbers = "enabled";
      vim = {
        use_system_clipboard = "always";
        # Absolute numbers in insert mode, like "vim.smartRelativeLine".
        toggle_relative_line_numbers = true;
      };
      # editor configuration
      format_on_save = "on";
      remove_trailing_whitespace_on_save = true;
      show_whitespaces = "all";
      tab_size = 4;
      hard_tabs = false;
      show_wrap_guides = true;
      wrap_guides = [ 120 ];
      preferred_line_length = 120;
      sticky_scroll.enabled = true;
      hover_popover_sticky = true;
      minimap.show = "never";
      code_lens = "on";
      inlay_hints.enabled = true;
      autosave = "off";
      restore_on_startup = "last_session";
      tabs.git_status = true;
      # use nix direnv
      load_direnv = "direct";
      # dev containers
      use_podman = dockerPath == "podman";
      # go settings
      lsp.gopls = {
        binary.path = "${pkgs.gopls}/bin/gopls";
        initialization_options = {
          local = "github.com/chainguard-dev";
          expandWorkspaceToModule = false;
          directoryFilters = [
            "-vendor"
            "-**/testdata"
            "-**/.git"
            "-**/node_modules"
          ];
          analyses = {
            shadow = false;
            fieldalignment = false;
          };
          codelenses = {
            gc_details = false;
            regenerate_cgo = false;
            tidy = false;
            upgrade_dependency = false;
            vendor = false;
          };
          hints.constantValues = true;
        };
      };
      dap.Delve.binary = "${pkgs.delve}/bin/dlv";
      # Claude Code speaks ACP to the agent panel. The adapter of Zed carries
      # a copy of the CLI, and this variable points it at the copy of
      # claude.nix, which holds the plugins and the permissions.
      agent_servers."claude-acp" = {
        type = "registry";
        env.CLAUDE_CODE_EXECUTABLE = lib.getExe pkgs.claude-code;
      };
      # Zed docks the agent panel left and every other panel right. These
      # settings hold the opposite layout.
      project_panel.dock = "left";
      git_panel.dock = "left";
      outline_panel.dock = "left";
      collaboration_panel.dock = "left";
      agent.dock = "right";
      # The left dock holds four panels with different default widths. This
      # setting gives them one width. Zed defaults to this value.
      resize_all_panels_in_dock = [ "left" ];
      # The inline assist runs on a model of Zed, never on the ACP agent.
      # Zed reads the key out of ANTHROPIC_API_KEY, thus the store holds no
      # secret.
      agent.inline_assistant_model = {
        provider = "anthropic";
        model = "claude-sonnet-5";
      };
      # mcp.nix holds every server, and "enableMcpIntegration" merges them
      # here. Zed 1.3.6 needs "args" for a local server, and the mcp module
      # drops an empty list, thus this one server needs both fields. An entry
      # of this attribute beats the merge. Delete it once Zed defaults "args".
      context_servers.nixos = {
        command = lib.getExe pkgs.mcp-nixos;
        args = [ ];
      };
      languages = lib.recursiveUpdate
        (lib.genAttrs predictionLanguages (_: { show_edit_predictions = true; }))
        {
          Go.formatter.language_server.name = "gopls";
          # The nix extension starts "nixd" first, and extraPackages holds
          # "nil" alone. That server needs no configuration to work.
          Nix.language_servers = [ "nil" ];
        };
      # disable a bunch of stuff for efficiency
      show_edit_predictions = false;
      edit_predictions.provider = "copilot";
      project_panel.auto_reveal_entries = false;
      search.search_on_type = false;
      reduce_motion = "on";
      auto_update = false;
      telemetry = {
        diagnostics = false;
        metrics = false;
      };
      # "..." keeps the exclusions of Zed, such as "**/.git".
      file_scan_exclusions = [
        "..."
        "**/.ammonite"
        "**/.bloop"
        "**/.metals"
        "**/.pytest_cache"
        "**/.vscode"
        "**/__pycache__"
        "**/bower_components"
        "**/dist"
        "**/env"
        "**/env-*"
        "**/node_modules"
        "**/tmp"
        "**/vendor"
        "**/venv"
        "**/*.sublime-*"
      ];
    };
  };
}
