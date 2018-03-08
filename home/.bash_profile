source $HOME/.bashrc


# The next line updates PATH for the Google Cloud SDK.
#source '/Users/mattknox/Desktop/google-cloud-sdk/path.bash.inc'

# The next line enables shell command completion for gcloud.
#source '/Users/mattknox/Desktop/google-cloud-sdk/completion.bash.inc'

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# OPAM configuration
. ~/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
