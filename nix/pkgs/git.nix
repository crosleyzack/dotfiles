{ pkgs, ... }:

{
  home.packages = with pkgs; [
    cosign
    gitsign
    codeowners
    pre-commit
  ];
  programs = {
      git = {
          enable = true;
          # allow large git files
          lfs = {
              enable = true;
              skipSmudge = false;
          };
          settings = {
              user = {
                  name = "crosleyzack";
                  email = "crosleyzack@gmail.com";
              };
              init.defaultBranch = "main";
              core.editor = "vim";
              color.ui = true;
              # use ssh for auth
              url = {
                  "ssh://git@github.com/crosleyzack" = {
                      insteadOf = "https://github.com/crosleyzack";
                  };
              };
              # always sign
              commit = {
                gpgsign = true;
                status = true;
              };
              tag = {
                gpgsign = true;
                forceSignAnnotated = true;
              };
              gitsign.connectorID = "https://accounts.google.com";
              gpg = {
                format = "x509";
                x509.program = "gitsign";
              };
              # setup aliases for convenience
              alias = {
                  unstage = "reset HEAD --";
                  staged = "diff --staged";
                  uncommit = "reset --soft HEAD^";
                  aliases = "config --get-regexp '^alias\\.'";
                  yolo = "push --force-with-lease";
                  by = "!f() { git log --author=$1; }; f";
                  # show the most recent N branches, defaults to 10
                  recent = "!git for-each-ref --count=\${@-10} --sort=-committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(contents:subject) (%(color:green)%(committerdate:short)%(color:reset))' #";
                  # create a new branch upstream and push to it
                  upstream = "push -u origin HEAD";
                  wash = "clean -fdx";
                  # get last N commits, defaults to 1
                  last = "!git log -\${@-1} HEAD #";
                  # show all changes from main
                  changes = "!git diff $(git main) -- .";
                  # get detailed version of last N commits, defaults to 1
                  details = "!git log -\${@-1} -p --format=fuller #";
                  tree = "log --all --graph --oneline --decorate --simplify-by-decoration --abbrev-commit";
                  main = "!git symbolic-ref refs/remotes/origin/HEAD | cut -d'/' -f4";
                  # return upstream main branch, or main if no upstream exists
                  upstream-branch = "!git remote | grep -q '^upstream$' && echo upstream || echo $(git main)";
                  # synchronize local main with upstream main and return to the current branch
                  sync = "!BRANCH=$(git branch --show-current) && UPSTREAM=$(git upstream-branch) && git checkout $(git main) && git fetch $UPSTREAM && git rebase $UPSTREAM && git checkout $BRANCH #";
              };
          }; 
      };
  };
}
