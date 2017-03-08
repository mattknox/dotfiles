export EDITOR="emacsclient -nw"
export HISTSIZE=10000
#export HISTCONTROL=ignoreboth

export HISTCONTROL=ignoreboth:erasedups
# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend

# makes multiple terminals append to, rather than overwrite, history from other terminals
export PROMPT_COMMAND="update_terminal_cwd; history -a"
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"


alias g="git"
alias gp='git pull'
alias gphm='git push heroku master'
alias gph="git push heroku master"
alias gs='git status'
alias gd='git diff'
alias gdm="git diff master"
alias gdmf="git diff master | egrep '^diff --git'"
alias gdom='git diff origin master'
alias gdhm='git diff heroku master'
alias gcom='git commit -m'
alias gcm='git commit -am'
alias gca='git commit --amend'
alias gb="git branch -vv"
alias gba="git branch -vv --all"
alias gmm="git merge master"
alias co="git checkout"
alias ms="git checkout master"
alias gpr="gpb; git pull-request" # depends on hub.
alias gpom="git pull origin master"
alias gg="git rev-list --all | xargs git grep"

alias lock="osascript -e 'do shell script \"open /System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app\"'"

#alias clobber_branches="git checkout master; git pull origin master; git branch | grep -v master | xargs git branch -d; git remote prune origin"
alias linecredit="git ls-tree --name-only -z -r HEAD | xargs -0 -n1 git diff --no-index --numstat /dev/null 2>/dev/null | grep -v '^-' | cut -f 3- | cut -d ' ' -f 3- | xargs -n1 git blame --line-porcelain | grep '^author ' | cut -d ' ' -f 2- | sort | uniq -c | sort -nr"
alias homesickup="homesick commit dotfiles; homesick push dotfiles"


alias be="bundle exec"
alias brc="source ~/.bashrc"
alias ll="ls -l"
alias hrc="heroku run rails c"
alias rdm="rake db:migrate; RAILS_ENV=test rake db:migrate; rake parallel:migrate"
alias rdr="rake db:rollback; RAILS_ENV=test rake db:rollback; rake parallel:drop parallel:create"
alias rc="rails c"
alias r="rails"

alias msup="git pull origin master; bundle install; rdm"
alias rup="git pull origin master; bundle install; rdm"

alias fin="t dm @schweindiver"

alias e=$EDITOR

alias cljizzle="lein run 2>&1 | grep WARNING | grep -v already | cut -b 10-"

function gpb {
    b=`git symbolic-ref --short HEAD`
    test $? == 0 || return;
    `git push origin $b`
}

export GOROOT=/usr/local/opt/go/libexec/
export GOPATH=$HOME/h/go
export PATH=/usr/local/bin:$PATH:$GOPATH/bin:

eval "$(hub alias -s)" # uncomment when I decide I want hub to wrap git-just trying for now.

if [ -f ~/.git-completion.bash ]; then
    . ~/.git-completion.bash
fi

__git_complete co _git_checkout
__git_complete g __git_main
__git_complete gp __git_pull

if [ -f ~/.work.sh ]; then
    source ~/.work.sh
fi

if [ -d ~/.rbenv ]; then
    eval "$(rbenv init -)"
fi

if [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
  export PROMPT_COMMAND=$(echo $PROMPT_COMMAND | sed -e 's/update_terminal_cwd; //')
fi

if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi

if [ -f ~/code/arcanist/bin/arc ]; then
    export PATH="$PATH:$HOME/code/arcanist/bin"
fi

# The next line updates PATH for the Google Cloud SDK.
source '/Users/mattknox/Desktop/google-cloud-sdk/path.bash.inc'

# The next line enables shell command completion for gcloud.
source '/Users/mattknox/Desktop/google-cloud-sdk/completion.bash.inc'
