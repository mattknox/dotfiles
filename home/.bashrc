export EDITOR="emacsclient -nw"

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

alias lock="osascript -e 'do shell script \"open /System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app\"'"

alias clobber_branches="git checkout master; git pull origin master; git branch | grep -v master | xargs git branch -d; git remote prune origin"
alias linecredit="git ls-tree --name-only -z -r HEAD | xargs -0 -n1 git diff --no-index --numstat /dev/null 2>/dev/null | grep -v '^-' | cut -f 3- | cut -d ' ' -f 3- | xargs -n1 git blame --line-porcelain | grep '^author ' | cut -d ' ' -f 2- | sort | uniq -c | sort -nr;"

alias be="bundle exec"
alias brc="source ~/.bashrc"
alias ll="ls -l"
alias hrc="heroku run rails c"

alias e=$EDITOR


function gpb {
    b=`git symbolic-ref --short HEAD`
    test $? == 0 || return;
    `git push origin $b`
}

export GOROOT=/usr/local/opt/go/libexec/
export GOPATH=$HOME/h/go
export PATH=$PATH:$GOPATH/bin
export HOMEBREW_GITHUB_API_TOKEN=f51c1cd369f4b4f5390a42b7c6465641122da4ec

eval "$(hub alias -s)" # uncomment when I decide I want hub to wrap git-just trying for now.

if [ -f ~/.git-completion.bash ]; then
    . ~/.git-completion.bash
fi

__git_complete co _git_checkout
__git_complete g __git_main
__git_complete gp __git_pull

source ~/.work.sh
