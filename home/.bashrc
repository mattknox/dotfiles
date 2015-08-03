alias gpom="git pull origin master"
alias gphm='git push heroku master'
alias gph="git push heroku master"
alias gs='git status'
alias gd='git diff'
alias gdm="git diff master"
alias gdom='git diff origin master'
alias gdhm='git diff heroku master'
alias gcm='git commit -m'
alias gcam='git commit -am'
alias gb="git branch"
alias gmm="git merge master"
alias ll="ls -l"
alias co="git checkout"
alias ms="git checkout master"
alias be="bundle exec"
alias brc="source ~/.bashrc"

function gpb {
    b=`git symbolic-ref --short HEAD`
    test $? == 0 || return;
    `git push origin $b`
}

export GOROOT=/usr/local/opt/go/libexec/
export GOPATH=$HOME/h/go
export PATH=$PATH:$GOPATH/bin
export HOMEBREW_GITHUB_API_TOKEN=f51c1cd369f4b4f5390a42b7c6465641122da4ec

# eval "$(hub alias -s)" # uncomment when I decide I want hub to wrap git.
