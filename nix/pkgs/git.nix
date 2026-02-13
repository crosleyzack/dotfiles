{ pkgs, ... }:

{
  home.packages = with pkgs; [
    cosign
    gitsign
    codeowners
    pre-commit
    github-runner
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
                  # show the most recent ten branches
                  recent = "for-each-ref --count=10 --sort=-committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(contents:subject) (%(color:green)%(committerdate:short)%(color:reset))'";
                  # create a new branch upstream and push to it
                  upstream = "push -u origin HEAD";
                  wash = "clean -fdx";
                  last = "log -1 HEAD";
                  # show all changes from main
                  changes = "!git diff $(git main) -- .";
                  details = "log -1 -p --format=fuller";
                  tree = "log --all --graph --oneline --decorate --simplify-by-decoration --abbrev-commit";
                  main = "!git symbolic-ref refs/remotes/origin/HEAD | cut -d'/' -f4";
                  update = "!BRANCH=$(git branch --show-current) && git checkout-m && git fetch && git rebase && git checkout $BRANCH # && git rebase-m";
                  checkout-m = "!git checkout $(git main)";
                  rebase-m = "!git rebase $(git main)";
                  # setup signed commits with gitsign
                  setup-signing = "!git config --local commit.gpgsign true && git config --local tag.gpgsign true && git config --local gpg.x509.program gitsign && git config --local gpg.format x509 && git config --local gitsign.connectorID https://accounts.google.com";
              };
          }; 
      };
  };
}
