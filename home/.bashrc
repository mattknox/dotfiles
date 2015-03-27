alias gpom="git pull origin master"
alias gphm='git push heroku master'
alias gph="git push heroku master"
alias gs='git status'
alias gd='git diff'
alias gdom='git diff origin master'
alias gdhm='git diff heroku master'
alias gcm='git commit -am'
alias gb="git branch"
alias ll="ls -l"
alias co="git checkout"
alias ms="git checkout master"

function gpb {
    b=`git symbolic-ref --short HEAD`
    test $? == 0 || return;
    `git push origin $b`
}

export GOROOT=/usr/local/opt/go/libexec/
export GOPATH=$HOME/h/go
export PATH=$PATH:$GOPATH/bin

# eval "$(hub alias -s)" # uncomment when I decide I want hub to wrap git.
