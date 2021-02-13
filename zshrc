export ZSH="/Users/gentryriggen/.oh-my-zsh"
ZSH_THEME="robbyrussell"
source $ZSH/oh-my-zsh.sh

export PATH=$PATH:/usr/local/bin
export ZSH=$HOME/.oh-my-zsh

eval $(/opt/homebrew/bin/brew shellenv)
[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh

plugins=(git zsh-autosuggestions autojump)

source $ZSH/oh-my-zsh.sh
source ~/.bash_profile

alias gcam="gca -m"
alias gsm="git smart-pull"
alias gsp="git smart-pull"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
[[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# place this after nvm initialization!
autoload -U add-zsh-hook
load-nvmrc() {
  if [[ -f .nvmrc && -r .nvmrc ]]; then
    nvm use
  elif [[ $(nvm version) != $(nvm version default)  ]]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

source <(kubectl completion zsh)
alias kb="kubectl"

listening() {
    if [ $# -eq 0 ]; then
        sudo lsof -iTCP -sTCP:LISTEN -n -P
    elif [ $# -eq 1 ]; then
        sudo lsof -iTCP -sTCP:LISTEN -n -P | grep -i --color $1
    else
        echo "Usage: listening [pattern]"
    fi
}

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/gentryriggen/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/gentryriggen/google-cloud-sdk/path.zsh.inc'; fi
# The next line enables shell command completion for gcloud.
if [ -f '/Users/gentryriggen/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/gentryriggen/google-cloud-sdk/completion.zsh.inc'; fi

# Helm/Kubernets
export HELM_HOME=$HOME/.helm
function helmet() {
  CLUSTER=$(kubectl config current-context)
  echo "Using cluster $CLUSTER"
  helm "$@" --tls --tls-cert $HELM_HOME/tls/$CLUSTER/cert.pem --tls-key $HELM_HOME/tls/$CLUSTER/key.pem
}
