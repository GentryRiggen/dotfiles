# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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

# ALIASES
alias kb="kubectl"
alias st="side-tools"
alias gbc="git branch --show-current | tr -d '\n' | pbcopy"
alias gcam="gca -m"
alias pn="pnpm"
alias gbclean="git for-each-ref --format '%(refname:short)' refs/heads | grep -v \"master\|main\" | xargs git branch -D"

listening() {
    if [ $# -eq 0 ]; then
        sudo lsof -iTCP -sTCP:LISTEN -n -P
    elif [ $# -eq 1 ]; then
        sudo lsof -iTCP -sTCP:LISTEN -n -P | grep -i --color $1
    else
        echo "Usage: listening [pattern]"
    fi
}
# Helm/Kubernets
export HELM_HOME=$HOME/.helm
function helmet() {
  CLUSTER=$(kubectl config current-context)
  echo "Using cluster $CLUSTER"
  helm "$@" --tls --tls-cert $HELM_HOME/tls/$CLUSTER/cert.pem --tls-key $HELM_HOME/tls/$CLUSTER/key.pem
}

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export TRUSTED_APPS_DB_HOST=wdplayground
export PD_DB_HOST=wdplayground
export CCX_SWB_DB_HOST=wdplayground
export PROXY_SWB_URL=http://wdPlayground:8080/swb-endpoint/swb/v1p0
export PROXY_BASE_URL=http://localhost:8081/api

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/gentryriggen/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/gentryriggen/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/gentryriggen/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/gentryriggen/google-cloud-sdk/completion.zsh.inc'; fi

source /opt/homebrew/opt/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
