{ pkgs, ... }:

{
  programs = {
      vscode = {
          # NOTE: does not work on ubuntu!
          enable = true;
          mutableExtensionsDir = false;
          profiles = {
              main = {
                  extensions = with pkgs; [
                    vscode-extensions.mkhl.direnv
                    vscode-extensions.vscodevim.vim
                    vscode-extensions.zhuangtongfa.material-theme
                    vscode-extensions.ms-vscode-remote.remote-containers
                    vscode-extensions.golang.go
                    vscode-extensions.ms-python.python
                    vscode-extensions.hashicorp.terraform
                    vscode-extensions.zxh404.vscode-proto3
                    vscode-extensions.github.copilot
                    vscode-extensions.anthropic.claude-code
                  ];
                  keybindings = [
                    {
                        "key" = "ctrl+\\";
                        "command" = "-workbench.action.splitEditor";
                    }
                    {
                        "key" = "ctrl+j";
                        "command" = "-workbench.action.togglePanel";
                    }
                    {
                        "key" = "ctrl+b";
                        "command" = "-workbench.action.toggleSidebarVisibility";
                    }
                    { # neovim based window navigation
                        "key" = "ctrl+w s";
                        "command" = "workbench.action.splitEditorRight";
                        "when" = "editorFocus";
                    }
                    {
                        "key" = "ctrl+w v";
                        "command" = "workbench.action.splitEditorDown";
                        "when" = "editorFocus";
                    }
                    {
                        "key" = "ctrl+w ctrl+n";
                        "command" = "workbench.action.files.newUntitledFile";
                    }
                    {
                        "key" = "ctrl+w q";
                        "command" = "workbench.action.closeActiveEditor";
                        "when" = "editorFocus";
                    }
                    { # close all other editors in group
                        "key" = "ctrl+w o";
                        "command" = "workbench.action.closeOtherEditors";
                        "when" = "editorFocus";
                    }
                    {
                        "key" = "ctrl+w shift+o";
                        "command" = "workbench.action.closeEditorsInOtherGroups";
                        "when" = "editorFocus";
                    }
                    {
                        "key" = "ctrl+w k";
                        "command" = "workbench.action.focusAbove";
                        "when" = "editorFocus";
                    }
                    {
                        "key" = "ctrl+w j";
                        "command" = "workbench.action.focusBelowGroup";
                        "when" = "editorFocus";
                    }
                    {
                        "key" = "ctrl+w h";
                        "command" = "workbench.action.focusLeftGroup";
                        "when" = "editorFocus";
                    }
                    {
                        "key" = "ctrl+w l";
                        "command" = "workbench.action.focusRightGroup";
                        "when" = "editorFocus";
                    }
                    {
                        "key" = "ctrl+w w";
                        "command" = "workbench.action.focusNextGroup";
                        "when" = "editorFocus";
                    }
                    {
                        "key" = "ctrl+w shift+w";
                        "command" = "workbench.action.focusPreviousGroup";
                        "when" = "editorFocus";
                    }
                    {
                        "key" = "ctrl+w t";
                        "command" = "workbench.action.focusFirstEditorGroup";
                        "when" = "editorFocus";
                    }
                    {
                        "key" = "ctrl+w b";
                        "command" = "workbench.action.focusLastEditorGroup";
                        "when" = "editorFocus";
                    }
                    {
                        "key" = "ctrl+w p";
                        "command" = "workbench.action.openPreviousRecentlyUsedEditorInGroup";
                        "when" = "editorFocus";
                    }
                    {
                        "key" = "ctrl+w r";
                        "command" = "workbench.action.moveEditorToNextGroup";
                        "when" = "editorFocus";
                    }
                    {
                        "key" = "ctrl+w shift+r";
                        "command" = "workbench.action.moveEditorToPreviousGroup";
                        "when" = "editorFocus";
                    }
                    {
                        "key" = "ctrl+w x";
                        "command" = "workbench.action.compareEditor.swapSides";
                        "when" = "editorFocus";
                    }
                    {
                        "key" = "ctrl+w shift+k";
                        "command" = "workbench.action.moveActiveEditorGroupUp";
                        "when" = "editorFocus";
                    }
                    {
                        "key" = "ctrl+w shift+j";
                        "command" = "workbench.action.moveActiveEditorGroupDown";
                        "when" = "editorFocus";
                    }
                    {
                        "key" = "ctrl+w shift+h";
                        "command" = "workbench.action.moveActiveEditorGroupLeft";
                        "when" = "editorFocus";
                    }
                    {
                        "key" = "ctrl+w shift+l";
                        "command" = "workbench.action.moveActiveEditorGroupRight";
                        "when" = "editorFocus";
                    }
                    {
                        "key" = "ctrl+w =";
                        "command" = "workbench.action.evenEditorWidths";
                        "when" = "editorFocus";
                    }
                    {
                        "key" = "ctrl+w -";
                        "command" = "workbench.action.decreaseViewHeight";
                        "when" = "editorFocus";
                    }
                    {
                        "key" = "ctrl+w shift+=";
                        "command" = "workbench.action.increaseViewHeight";
                        "when" = "editorFocus";
                    }
                    {
                        "key" = "ctrl+w shift+.";
                        "command" = "workbench.action.increaseViewWidth";
                        "when" = "editorFocus";
                    }
                    {
                        "key" = "ctrl+w shift+,";
                        "command" = "workbench.action.decreaseViewWidth";
                        "when" = "editorFocus";
                    }
                    {
                        "key" = "ctrl+w shift+\\";
                        "command" = "workbench.action.editorLayoutSingle";
                        "when" = "editorFocus";
                    }
                    {
                        "key" = "ctrl+w ;";
                        "command" = "workbench.action.terminal.focus";
                        "when" = "editorFocus";
                    }
                    {
                        "key" = "ctrl+w shift+;";
                        "command" = "workbench.action.togglePanel";
                    }
                    {
                        "key" = "ctrl+w ;";
                        "command" = "workbench.action.focusActiveEditorGroup";
                        "when" = "terminalFocus";
                    }
                    {
                        "key" = "ctrl+w z";
                        "command" = "workbench.action.toggleEditorWidths";
                        "when" = "editorFocus";
                    }
                    {
                        "key" = "ctrl+w \\";
                        "command" = "workbench.action.showAllEditorsByMostRecentlyUsed";
                    }
                    {
                        "key" = "ctrl+w tab";
                        "command" = "workbench.action.nextEditorInGroup";
                        "when" = "editorFocus";
                    }
                    {
                        "key" = "ctrl+w shift+tab";
                        "command" = "workbench.action.previousEditorInGroup";
                        "when" = "editorFocus";
                    }
                    { # TODO only when activeEditorGroupFirst
                        "key" = "ctrl+w `";
                        "command" = "workbench.action.focusSideBar";
                    }
                    { # TODO only when activeEditorGroupFirst
                        "key" = "ctrl+w shift+`";
                        "command" = "workbench.action.toggleSidebarVisibility";
                    }
                    {
                        "key" = "ctrl+w l";
                        "command" = "workbench.action.focusFirstEditorGroup";
                        "when" = "sideBarFocus";
                    }
                    {
                        "key" = "ctrl+w j";
                        "command" = "workbench.action.nextSideBarView";
                        "when" = "sideBarFocus";
                    }
                    {
                        "key" = "ctrl+w k";
                        "command" = "workbench.action.previousSideBarView";
                        "when" = "sideBarFocus";
                    }
                    {
                        "key" = "ctrl+/";
                        "command" = "-editor.action.blockComment";
                        "when" = "editorTextFocus && !editorReadonly && editorHasSelection";
                    }
                    {
                        "key" = "ctrl+/";
                        "command" = "editor.action.commentLine";
                        "when" = "editorTextFocus && !editorReadonly && editorHasSelection";
                    }
                    {
                        "key" = "tab";
                        "command" = "editor.action.inlineSuggest.commit";
                        "when" = "textInputFocus && inlineSuggestionHasIndentationLessThanTabSize && inlineSuggestionVisible && !editorTabMovesFocus";
                    }
                    {
                        "key" = "ctrl+alt+down";
                        "command" = "-workbench.action.files.newUntitledFile";
                    }
                    { # debugging
                        "key" = "ctrl+; ]";
                        "command" = "editor.action.marker.next";
                        "when" = "editorFocus";
                    }
                    {
                        "key" = "ctrl+; shift+]";
                        "command" = "editor.action.marker.prev";
                        "when" = "editorFocus";
                    }
                    {
                        "key" = "ctrl+; shift+p";
                        "command" = "editor.action.revealDefinitionAside";
                        "when" = "editorFocus";
                    }
                    {
                        "key" = "ctrl+; p";
                        "command" = "editor.action.peekTypeDefinition";
                        "when" = "editorFocus";
                    }
                    {
                        "key" = "ctrl+; `";
                        "command" = "editor.action.inlineSuggest.trigger";
                        "when" = "editorFocus";
                    }
                    {
                        "key" = "ctrl+; d";
                        "command" = "testing.debugSelected";
                        "when" = "editorTextFocus";
                    }
                    {
                        "key" = "ctrl+; shift+d";
                        "command" = "testing.debugCurrentFile";
                        "when" = "editorTextFocus";
                    }
                    {
                        "key" = "ctrl+; b";
                        "command" = "editor.debug.action.toggleBreakpoint";
                        "when" = "editorTextFocus";
                    }
                    {
                        "key" = "ctrl+; e";
                        "command" = "editor.debug.action.editBreakpoint";
                        "when" = "editorTextFocus";
                    }
                    {
                        "key" = "ctrl+; w";
                        "command" = "debug.setWatchExpression";
                        "when" = "editorTextFocus";
                    }
                    {
                        "key" = "ctrl+; f";
                        "command" = "editor.toggleFoldRecursively";
                        "when" = "editorTextFocus";
                    }
                    { # ▶
                        "key" = "ctrl+l";
                        "command" = "workbench.action.debug.continue";
                        "when" = "inDebugMode && editorTextFocus && debugState == 'stopped'";
                    }
                    { # ↷
                        "key" = "ctrl+h";
                        "command" = "workbench.action.debug.stepOver";
                        "when" = "inDebugMode && editorTextFocus && debugState == 'stopped'";
                    }
                    { # ↓
                        "key" = "ctrl+j";
                        "command" = "workbench.action.debug.stepInto";
                        "when" = "inDebugMode && editorTextFocus && debugState == 'stopped'";
                    }
                    { # ↑
                        "key" = "ctrl+k";
                        "command" = "workbench.action.debug.stepOut";
                        "when" = "inDebugMode && editorTextFocus && debugState == 'stopped'";
                    }
                    { # ↺
                        "key" = "ctrl+r";
                        "command" = "workbench.action.debug.restart";
                        "when" = "inDebugMode && editorTextFocus && debugState != 'inactive'";
                    }
                    {
                        "key" = "ctrl+q";
                        "command" = "workbench.action.debug.disconnect";
                        "when" = "inDebugMode && editorTextFocus && debugState != 'inactive'";
                    }
                    {
                        "key" = "q";
                        "command" = "editor.action.inlineSuggest.hide";
                        "when" = "inlineSuggestionVisible";
                    }
                    {
                        "key" = "ctrl+f1";
                        "command" = "workbench.action.openDefaultKeybindingsFile";
                    }
                    {
                        "key" = "ctrl+pageup";
                        "command" = "-workbench.action.previousEditor";
                    }
                    {
                        "key" = "ctrl+shift+/";
                        "command" = "workbench.action.openGlobalKeybindings";
                        "when" = "editorFocus";
                    }
                  ];
                  userSettings = {
                    "window.newWindowProfile" = "main";
                    # theming
                    "workbench.colorTheme" = "One Dark Pro Night Flat";
                    "editor.fontFamily" = "'Monaspice', monospace";
                    "editor.fontSize" = 14.5;
                    "editor.fontVariations" = true;
                    "editor.fontLigatures" = false;
                    "editor.bracketPairColorization.enabled" = true;
                    "terminal.integrated.fontFamily" = "'Monaspice', monospace";
                    "terminal.integrated.suggest.enabled" = true;
                    "terminal.integrated.shellIntegration.enabled" = true;
                    "terminal.integrated.profile.linux" = {
                      "zsh_nix" = {
                        "path" = "$HOME/.nix-profile/bin/zsh";
                        "icon" = "terminal";
                      };
                    };
                    "terminal.integrated.defaultProfile.linux" = "zsh_nix";
                    # vim bindings
                    "extensions.experimental.affinity" = {
                        "vscodevim.vim" = 1;
                        "asvetliakov.vscode-neovim" = 1;
                    };
                    "vim.statusBarColorControl" = false;
                    "vim.report" = 2000;
                    "vim.showmodename" = false;
                    "vim.useSystemClipboard" = true;
                    "vim.highlightedyank.enable" = true;
                    "vim.history" = 9000;
                    "vim.smartRelativeLine" = true;
                    "vim.autoindent" = false;
                    "vim.easymotionDimBackground" = false;
                    "vim.joinspaces" = false;
                    "vim.startofline" = false;
                    "vim.targets.smartQuotes.breakThroughLines" = false;
                    "vim.leader" = "space";
                    "vim.easymotion" = false;
                    "vim.incsearch" = false;
                    "vim.useCtrlKeys" = true;
                    "vim.hlsearch" = true;
                    "vim.vimrc.enable" = false;
                    # editor configuration
                    "editor.detectIndentation" = true;
                    "editor.inlineSuggest.enabled" = true;
                    "editor.largeFileOptimizations" = true;
                    "editor.lineNumbers" = "relative";
                    "editor.hover.sticky" = true;
                    "editor.formatOnPaste" = true;
                    "editor.formatOnSave" = true;
                    "editor.folding" = true;
                    "editor.foldingHighlight" = true;
                    "editor.foldingImportsByDefault" = false;
                    "editor.foldingStrategy" = "auto";
                    "editor.rulers" = [
                        120
                    ];
                    "editor.insertSpaces" = true;
                    "editor.minimap.enabled" = false;
                    "editor.renderWhitespace" = "all";
                    "editor.trimAutoWhitespace" = true;
                    "editor.stickyScroll.enabled" = true;
                    "editor.tabSize" = 4;
                    "window.restoreFullscreen" = true;
                    "window.menuBarVisibility" = "compact";
                    "window.density.editorTabHeight" = "compact";
                    "workbench.editor.highlightModifiedTabs" = true;
                    "workbench.editor.splitInGroupLayout" = "horizontal";
                    "workbench.editor.splitSizing" = "distribute";
                    "workbench.secondarySideBar.defaultVisibility" = "hidden";
                    "workbench.startupEditor" = "readme";
                    "dev.containers.copyGitConfig" = false;
                    # for fedora machines
                    "dev.containers.dockerPath" = "podman";
                    # go settings
                    "gopls" = {
                        "formatting.local" = "github.com/chainguard-dev";
                    };
                    "go.useLanguageServer" = true;
                    "go.lintTool" = "golint";
                    "go.lintOnSave" = "workspace";
                    "go.delveConfig" = {};
                    "go.toolsManagement.autoUpdate" = true;
                    "go.testTimeout" = "200s";
                    "go.testFlags" = [
                        "-test.count=1"
                    ];
                    "go.formatTool" = "gofmt";
                    "go.inlayHints.constantValues" = true;
                    "go.inferGopath" = true;
                    "[go]" = {
                        "editor.codeLens" = true;
                        "editor.defaultFormatter" = "golang.go";
                    };
                    # disable a bunch of stuff for efficiency
                    "chat.mcp.access" = "none";
                    "chat.commandCenter.enabled" = false;
                    "chat.agent.enabled" = false;
                    "chat.agent.maxRequests" = 0;
                    "chat.sendElementsToChat.enabled" = false;
                    "diffEditor.codeLens" = false;
                    "explorer.autoReveal" = false;
                    "extensions.autoUpdate" = false;
                    "extensions.ignoreRecommendations" = true;
                    "files.autoSave" = "off";
                    "git.openRepositoryInParentFolders" = "never";
                    "githubPullRequests.pullBranch" = "never";
                    "github.copilot.chat.agent.autoFix" = false;
                    "github.copilot.chat.agent.runTasks" = false;
                    "github.copilot.chat.codesearch.enabled" = false;
                    "github.copilot.chat.startDebugging.enabled" = false;
                    "github.copilot.chat.copilotDebugCommand.enabled" = false;
                    "github.copilot.chat.setupTests.enabled" = false;
                    "github.copilot.chat.edits.newNotebook.enabled" = false;
                    "github.copilot.chat.notebook.followCellExecution.enabled" = false;
                    "github.copilot.enable" = {
                        "*" = false;
                        "dockerfile" = true;
                        "go" = true;
                        "makefile" = true;
                        "shellscript" = true;
                        "sql" = true;
                        "typescript" = true;
                        "python" = true;
                    };
                    "github.copilot.advanced" = {
                        "authPermissions" = "minimal";
                    };
                    "notebook.experimental.generate" = false;
                    "search.followSymlinks" = false;
                    "search.collapseResults" = "alwaysCollapse";
                    "search.searchOnType" = false;
                    "telemetry.telemetryLevel" = "crash";
                    "telemetry.feedback.enabled" = false;
                    "telemetry.editStats.enabled" = false;
                    "window.customTitleBarVisibility" = "never";
                    "window.commandCenter" = false;
                    "workbench.reduceMotion" = "on";
                    "workbench.layoutControl.enabled" = false;
                    "workbench.settings.showAISearchToggle" = false;
                    "files.watcherExclude" = {
                        "**/.git/objects/**" = true;
                        "**/.git/subtree-cache/**" = true;
                        "**/node_modules/**" = true;
                        "**/env/**" = true;
                        "**/venv/**" = true;
                        "env-*" = true;
                        "**/tmp/**" = true;
                        "**/dist/**" = true;
                        "**/.bloop" = true;
                        "**/.metals" = true;
                        "**/.ammonite" = true;
                    };
                    "search.exclude" = {
                        "**/node_modules" = true;
                        "**/bower_components" = true;
                        "**/env" = true;
                        "**/venv" = true;
                    };
                    "files.exclude" = {
                        "**/.git" = true;
                        "**/.DS_Store" = true;
                        "**/.vscode" = true;
                        "**/__pycache__" = true;
                        "**/.pytest_cache" = true;
                        "**/node_modules" = true;
                        "venv" = true;
                        "*.sublime-*" = true;
                        "**/tmp/**" = true;
                        "**/node_modules/**" = true;
                        "**/.git/objects/**" = true;
                        "**/.git/subtree-cache/**" = true;
                        "**/dist/**" = true;
                    };
                  };
              };
          };
      };
  };
}
