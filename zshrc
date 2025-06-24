# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

if [ -d "/Users/gentryriggen" ]; then
  export MY_HOME="/Users/gentryriggen"
else
  export MY_HOME="/Users/griggen"
fi

export ZSH="$MY_HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
source $ZSH/oh-my-zsh.sh

export PATH=$PATH:/usr/local/bin
export ZSH=$HOME/.oh-my-zsh

eval $(/opt/homebrew/bin/brew shellenv)
[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh

plugins=(git zsh-autosuggestions autojump)

source $ZSH/oh-my-zsh.sh
source ~/.bash_profile

[[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh

# ALIASES
alias kb="kubectl"
alias st="side-tools"
alias gbc="git branch --show-current | tr -d '\n' | pbcopy"
alias gcam="git commit -v -a -m"
alias pn="pnpm"
alias gbclean="git for-each-ref --format '%(refname:short)' refs/heads | grep -v \"master\|main\" | xargs git branch -D"
alias dstop='docker stop $(docker ps -a -q)'
alias drmf='docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)'

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
if [ -f "$MY_HOME/google-cloud-sdk/path.zsh.inc" ]; then . "$MY_HOME/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$MY_HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$MY_HOME/google-cloud-sdk/completion.zsh.inc"; fi

source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme


autoload -U add-zsh-hook

eval "$($MY_HOME/.local/bin/mise activate zsh)"

# Autocomplete
autoload -U +X bashcompinit && bashcompinit

# Terraform CLI Autocomplete
complete -o nospace -C /opt/homebrew/bin/terraform terraform

# Azure CLI Autocomplete
source $(brew --prefix)/etc/bash_completion.d/az

# Azure helpers
function azSwitch() {
    if [ $# -eq 0 ]; then
        echo "❌ Error: No subscription specified"
        echo "📋 Usage: azSwitch <personal | jbrec-stage | jbrec-uat | jbrec-prod>"
        echo "💡 Available subscriptions:"
        echo "   • personal     - Personal Azure subscription"
        echo "   • jbrec-stage  - JBREC CP2-DEV environment"
        echo "   • jbrec-uat    - JBREC CP2-UAT environment"
        echo "   • jbrec-prod   - JBREC CP2 production environment"
        return 1
    fi
    
    local subscription_name=$1
    echo "🔄 Azure subscription switch initiated..."
    echo "🎯 Target subscription: $subscription_name"
    echo ""
    
    # Source environment variables based on subscription
    if [ "$subscription_name" = "personal" ]; then
        echo "🏠 Switching to PERSONAL subscription..."
        echo "📁 Sourcing environment file: $MY_HOME/az-profiles/personal.sh"
        source "$MY_HOME/az-profiles/personal.sh"
        echo "🔧 Setting Azure subscription to personal account..."
        az login --tenant 981fd78f-9d44-4f87-858d-1eb69653e24b
        az account set --subscription 70ea4c9a-be27-4e36-bdf4-28a240e7279c
        local subscription_id="70ea4c9a-be27-4e36-bdf4-28a240e7279c"
        
    elif [ "$subscription_name" = "jbrec-dev" ] || [ "$subscription_name" = "jbrec-stage" ]; then
        echo "🧪 Switching to JBREC DEV/STAGE environment..."
        echo "📁 Sourcing environment file: $MY_HOME/az-profiles/jbrec-stage.sh"
        source "$MY_HOME/az-profiles/jbrec-stage.sh"
        echo "🔧 Setting Azure subscription to CP2-DEV (jbrec.org)..."
        az login --tenant dd7a3570-f807-454c-93e5-f13851305c20
        az account set --subscription 8b87b5c8-3f0d-4f48-a512-5e7b553dd51b
        local subscription_id="8b87b5c8-3f0d-4f48-a512-5e7b553dd51b"

    elif [ "$subscription_name" = "jbrec-uat" ]; then
        echo "🚀 Switching to JBREC UAT environment..."
        echo "📁 Sourcing environment file: $MY_HOME/az-profiles/jbrec-uat.sh"
        source "$MY_HOME/az-profiles/jbrec-uat.sh"
        echo "🔧 Setting Azure subscription to CP2-UAT (jbrec.org)..."
        az login --tenant dd7a3570-f807-454c-93e5-f13851305c20
        az account set --subscription 33c0f6b9-6cc0-43b6-a2b5-14167d3b74b1
        local subscription_id="33c0f6b9-6cc0-43b6-a2b5-14167d3b74b1"
        
    elif [ "$subscription_name" = "jbrec-prod" ]; then
        echo "🏭 Switching to JBREC PRODUCTION environment..."
        echo "⚠️  WARNING: You are switching to PRODUCTION! ⚠️"
        echo "📁 Sourcing environment file: $MY_HOME/az-profiles/jbrec-prod.sh"
        source "$MY_HOME/az-profiles/jbrec-prod.sh"
        echo "🔧 Setting Azure subscription to CP2 (jbrecclient.onmicrosoft.com)..."
        az login --tenant ad1df303-4824-4d47-aa4e-f36cac248cf7
        az account set --subscription bdc94a1f-27a0-41fa-9174-b24135ecbc05
        local subscription_id="bdc94a1f-27a0-41fa-9174-b24135ecbc05"

    elif [ "$subscription_name" = "jbrec-non-prod" ]; then
        echo "🏭 Switching to JBREC NON-PROD environment..."
        echo "📁 Sourcing environment file: $MY_HOME/az-profiles/jbrec-non-prod.sh"
        source "$MY_HOME/az-profiles/jbrec-non-prod.sh"
        echo "🔧 Setting Azure subscription to NON-PROD (jbrec.org)..."
        az login --tenant dd7a3570-f807-454c-93e5-f13851305c20
        az account set --subscription 2f63326e-e2de-41cf-afbd-1966b3c3a813
        local subscription_id="2f63326e-e2de-41cf-afbd-1966b3c3a813"
        
    else
        echo "❌ Error: Unknown subscription '$subscription_name'"
        echo "📋 Available options: personal, jbrec-stage, jbrec-uat, jbrec-prod"
        return 1
    fi

    if [ $? -eq 0 ]; then
        echo ""
        echo "✅ Successfully switched to subscription: $subscription_name"
        echo "🆔 Subscription ID: $subscription_id"
        echo "🔍 Verifying current subscription..."
        local current_sub=$(az account show --query name -o tsv 2>/dev/null)
        if [ $? -eq 0 ]; then
            echo "📊 Current subscription: $current_sub"
        else
            echo "⚠️  Could not verify current subscription (you may need to login)"
        fi
        echo "🎉 Azure environment switch complete!"
    else
        echo ""
        echo "❌ Failed to switch subscription!"
        echo "🔍 Please check:"
        echo "   • Azure CLI is installed and logged in"
        echo "   • Subscription name is correct"
        echo "   • You have access to the subscription"
        return 1
    fi
}
export PATH="/opt/homebrew/opt/postgresql@14/bin:$PATH"
