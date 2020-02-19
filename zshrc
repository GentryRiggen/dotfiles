export PATH=$PATH:/usr/local/bin
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME=""

plugins=(git zsh-autosuggestions autojump)

source $ZSH/oh-my-zsh.sh
source ~/.bash_profile

alias gcam="gca -m"
alias gsm="git smart-pull"
alias gsp="git smart-pull"

autoload -U promptinit; promptinit
prompt pure

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# ENV VARS
# export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-13.jdk/Contents/Home
export JAVA_HOME=`/usr/libexec/java_home -v 1.8.0_242`
export ANDROID_HOME=$HOME/Library/Android/sdk
export ANDROID_SDK=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_SDK/platform-tools
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=/usr/local/sbin:$PATH
export PATH=$PATH:/Applications/Genymotion.app/Contents/MacOS/tools/
export PATH=$PATH:/Applications/MySQLWorkbench.app/Contents/MacOS
export SKIP_RESOURCES=1
export APP_NO_CHECKOUT_HOOK=1

export PATH="$HOME/.fastlane/bin:$PATH"

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

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/gentryriggen/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/gentryriggen/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/gentryriggen/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/gentryriggen/google-cloud-sdk/completion.zsh.inc'; fi

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

export PATH=$PATH:~/dev/apache-maven-3.6.3/bin
export PATH=$PATH:$JAVA_HOME/bin

# Helm/Kubernets
export HELM_HOME=$HOME/.helm
function helmet() {
  CLUSTER=$(kubectl config current-context)
  echo "Using cluster $CLUSTER"
  helm "$@" --tls --tls-cert $HELM_HOME/tls/$CLUSTER/cert.pem --tls-key $HELM_HOME/tls/$CLUSTER/key.pem
}
