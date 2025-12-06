{ pkgs, ... }:

{
  programs = {
      git = {
          enable = true;
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
              url = {
                  "ssh://git@github.com/crosleyzack" = {
                      insteadOf = "https://github.com/crosleyzack";
                  };
              };
              gpg.format = "ssh";
              alias = {
                  unstage = "reset HEAD --";
                  staged = "diff --staged";
                  uncommit = "reset --soft HEAD^";
                  aliases = "config --get-regexp '^alias\\.'";
                  yolo = "push --force-with-lease";
                  by = "!f() { git log --author=$1; }; f";
                  recent = "for-each-ref --count=10 --sort=-committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(contents:subject) (%(color:green)%(committerdate:short)%(color:reset))'";
                  upstream = "push -u origin HEAD";
                  wash = "clean -fdx";
                  last = "log -1 HEAD";
                  changes = "!git diff $(git main) -- .";
                  details = "log -1 -p --format=fuller";
                  tree = "log --all --graph --oneline --decorate --simplify-by-decoration --abbrev-commit";
                  main = "!git symbolic-ref refs/remotes/origin/HEAD | cut -d'/' -f4";
                  update = "!BRANCH=$(git branch --show-current) && git checkout-m && git fetch && git rebase && git checkout $BRANCH # && git rebase-m";
                  checkout-m = "!git checkout $(git main)";
                  rebase-m = "!git rebase $(git main)";
                  setup-signing = "!git config --local commit.gpgsign true && git config --local tag.gpgsign true && git config --local gpg.x509.program gitsign && git config --local gpg.format x509 && git config --local gitsign.connectorID https://accounts.google.com";
              };
          }; 
      };
      gh = {
          enable = true;
          settings = {
              editor = "vim";
              git_protocol = "ssh";
              color_labels = "enabled";
              spinner = "enabled";
          };
      };
  };
}
