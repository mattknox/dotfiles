export EDITOR="emacsclient -nw"
alias e="emacsclient -nw"

export HISTSIZE=10000
setopt HIST_IGNORE_DUPS
#export HISTCONTROL=ignoreboth

#export HISTCONTROL=ignoreboth:erasedups
# When the shell exits, append to the history file instead of overwriting it
# shopt -s histappend

# makes multiple terminals append to, rather than overwrite, history from other terminals
#export PROMPT_COMMAND="update_terminal_cwd; history -a"
#export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"


# Function to source a shell script if it exists
source_if_exists() {
  local script_path="$1"

  if [ -f "$script_path" ]; then
    echo "Sourcing $script_path..."
    source "$script_path"
  else
    echo "File $script_path does not exist. Skipping."
  fi
}

export AUTOCOMMIT_PATHS="~/org"
export REDDIT_SOURCE_DIR="~/h/reddit"

# TODO: should I make this look at init.defaultBranch?
#alias git_default_branch="git rev-parse --abbrev-ref origin/HEAD | sed 's/.*\///'"
alias git_default_branch="git remote show origin | grep HEAD | cut -d':' -f2"
alias gp='git pull'
alias gphm='git push heroku master'
alias gph="git push heroku master"
alias gs='git status'
alias gd='git diff'
alias gdm="git diff \$(git_default_branch)"
alias gdmf="git diff \$(git_default_branch) | egrep '^diff --git'"
alias gdom='git diff origin \$(git_default_branch)'
alias gdhm='git diff heroku \$(git_default_branch)'
alias gcom='git commit -m'
alias gcm='git commit -am'
alias gca='git commit --amend'
alias gb="git branch -vv"
alias gba="git branch -vv --all"
alias gmm="git merge \$(git_default_branch)"
alias co="git checkout"
alias ms="git checkout \$(git_default_branch)"
alias gpr="gpb; git pull-request" # depends on hub.
alias gpom="git pull origin \$(git_default_branch)"
alias gg="git rev-list --all | xargs git grep"
export KNOXTESTZ="this variable set in .zshrc"

#alias clobber_branches="git checkout master; git pull origin master; git branch | grep -v master | xargs git branch -d; git remote prune origin"
alias linecredit="git ls-tree --name-only -z -r HEAD | xargs -0 -n1 git diff --no-index --numstat /dev/null 2>/dev/null | grep -v '^-' | cut -f 3- | cut -d ' ' -f 3- | xargs -n1 git blame --line-porcelain | grep '^author ' | cut -d ' ' -f 2- | sort | uniq -c | sort -nr"
alias homesickup="homesick commit dotfiles; homesick push dotfiles"


alias be="bundle exec"
alias ll="ls -Glah"
alias hrc="heroku run rails c"
alias rdm="rake db:migrate; RAILS_ENV=test rake db:migrate; rake parallel:migrate"
alias rdr="rake db:rollback; RAILS_ENV=test rake db:rollback; rake parallel:drop parallel:create"
alias rc="rails c"
alias r="rails"

alias msup="git pull origin \$(git_default_branch); bundle install; rdm"
alias rup="git pull origin \$(git_default_branch); bundle install; rdm"

alias fin="t dm @schweindiver"
alias cljizzle="lein run 2>&1 | grep WARNING | grep -v already | cut -b 10-"

alias gpb="git push origin \$(git symbolic-ref --short HEAD)"


# Apple Silicon macs have homebrew root in /opt/homebrew
if [ "arm" = `uname -p` ]
then
    export GOROOT='/opt/homebrew/opt/go/libexec'
else
    export GOROOT='/opt/homebrew/opt/go/libexec' #/usr/local/opt/go/libexec/
fi


export GOPATH=$HOME/h/go
export PATH=/usr/local/bin:/opt/homebrew/sbin:$PATH:$GOPATH/bin:

eval "$(hub alias -s)"

if [ -f ~/.work.sh ]; then
    source ~/.work.sh
    print "200: ~/.work.sh found."
else
    print "404: ~/.work.sh not found."
fi


if [ -d ~/.rbenv ]; then
    eval "$(rbenv init -)"
fi

if [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
  export PROMPT_COMMAND=$(echo $PROMPT_COMMAND | sed -e 's/update_terminal_cwd; //')
fi

# git clone https://github.com/lukechilds/zsh-nvm.git ~/.zsh-nvm
source_if_exists ~/.zsh-nvm/zsh-nvm.plugin.zsh

export MFA_DEVICE='arn:aws:iam::210246326331:mfa/matt.knox'
export AWS_SDK_LOAD_CONFIG=true
