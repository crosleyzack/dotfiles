
# For efficiency, limit prompt options
SPACESHIP_PROMPT_ORDER=(
    dir            # Current directory section
    host           # Hostname section
    git            # Git section (git_branch + git_status)
    package        # Package version
    python         # Python section
    golang         # Go section
    docker         # Docker section
    docker_compose # Docker section
    gcloud         # Google Cloud Platform section
    kubectl        # Kubectl context section
    exec_time      # Execution time
    line_sep       # Line break
    exit_code      # Exit code section
    char           # Prompt character
)

# Instead, show host so we know if we are in toolbox
SPACESHIP_DIR_SHOW=always
SPACESHIP_HOST_SHOW=always
SPACESHIP_GIT_SHOW=always
SPACESHIP_PROMPT_ASYNC=true

# setup vi mode
spaceship add --after line_sep vi_mode
spaceship_vi_mode_enable
SPACESHIP_VI_MODE_SHOW=1
# indicate when in normal mode, nothing in insert
SPACESHIP_VI_MODE_INSERT=
SPACESHIP_VI_MODE_NORMAL="⋂ "
