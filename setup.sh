#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# Idempotent dotfiles setup script
# Safe to run multiple times — skips what's already done, backs up conflicts
# =============================================================================

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
BACKUP_CREATED=false

info()  { printf "\033[1;34m[INFO]\033[0m  %s\n" "$1"; }
ok()    { printf "\033[1;32m[OK]\033[0m    %s\n" "$1"; }
warn()  { printf "\033[1;33m[WARN]\033[0m  %s\n" "$1"; }
skip()  { printf "\033[0;90m[SKIP]\033[0m  %s\n" "$1"; }

backup_file() {
    if [ ! "$BACKUP_CREATED" = true ]; then
        mkdir -p "$BACKUP_DIR"
        BACKUP_CREATED=true
    fi
    cp -RL "$1" "$BACKUP_DIR/" 2>/dev/null || true
    warn "Backed up $1 → $BACKUP_DIR/"
}

# Create a symlink, backing up any existing file that isn't already correct
link_file() {
    local src="$1"
    local dest="$2"

    # Already a symlink pointing to the right place
    if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
        skip "$dest already linked"
        return
    fi

    # Something else exists — back it up
    if [ -e "$dest" ] || [ -L "$dest" ]; then
        backup_file "$dest"
        rm -rf "$dest"
    fi

    # Ensure parent directory exists
    mkdir -p "$(dirname "$dest")"

    ln -s "$src" "$dest"
    ok "Linked $dest → $src"
}

# =============================================================================
# 1. Shell config symlinks
# =============================================================================
info "Setting up shell config symlinks..."

link_file "$DOTFILES_DIR/zshrc"        "$HOME/.zshrc"
link_file "$DOTFILES_DIR/bash_profile" "$HOME/.bash_profile"
link_file "$DOTFILES_DIR/p10k.zsh"     "$HOME/.p10k.zsh"

# =============================================================================
# 2. Vim config symlinks
# =============================================================================
info "Setting up Vim config..."

link_file "$DOTFILES_DIR/vimrc"  "$HOME/.vimrc"
link_file "$DOTFILES_DIR/xvimrc" "$HOME/.xvimrc"

# Symlink vim autoload (for vim-plug)
mkdir -p "$HOME/.vim"
link_file "$DOTFILES_DIR/vim/autoload" "$HOME/.vim/autoload"

# =============================================================================
# 3. Git template hooks
# =============================================================================
info "Setting up Git template hooks..."

link_file "$DOTFILES_DIR/git_template" "$HOME/.git_template"

# Configure git to use the template directory
CURRENT_TEMPLATE="$(git config --global init.templatedir 2>/dev/null || true)"
if [ "$CURRENT_TEMPLATE" = "$HOME/.git_template" ]; then
    skip "Git template dir already configured"
else
    git config --global init.templatedir "$HOME/.git_template"
    ok "Set git init.templatedir → ~/.git_template"
fi

# Ensure hooks are executable
chmod +x "$DOTFILES_DIR/git_template/hooks/"* 2>/dev/null || true

# =============================================================================
# 4. Hyper terminal config
# =============================================================================
info "Setting up Hyper terminal config..."

link_file "$DOTFILES_DIR/hyper.js" "$HOME/.hyper.js"

# =============================================================================
# 5. Claude Code config
# =============================================================================
info "Setting up Claude Code config..."

link_file "$DOTFILES_DIR/claude/settings.json"        "$HOME/.claude/settings.json"
link_file "$DOTFILES_DIR/ccstatusline/settings.json"   "$HOME/.config/ccstatusline/settings.json"

# =============================================================================
# 6. Homebrew (install if missing, then install packages)
# =============================================================================
info "Checking Homebrew..."

if command -v brew &>/dev/null; then
    skip "Homebrew already installed"
else
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Source brew for the rest of this script
    if [ -f /opt/homebrew/bin/brew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    ok "Homebrew installed"
fi

BREW_PACKAGES=(autojump mise)

for pkg in "${BREW_PACKAGES[@]}"; do
    if brew list "$pkg" &>/dev/null; then
        skip "brew: $pkg already installed"
    else
        info "Installing $pkg..."
        brew install "$pkg"
        ok "Installed $pkg"
    fi
done

# =============================================================================
# 7. Oh My Zsh (install if missing)
# =============================================================================
info "Checking Oh My Zsh..."

if [ -d "$HOME/.oh-my-zsh" ]; then
    skip "Oh My Zsh already installed"
else
    info "Installing Oh My Zsh..."
    RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    ok "Oh My Zsh installed"
fi

# =============================================================================
# 8. Zsh plugins
# =============================================================================
info "Checking Zsh plugins..."

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# zsh-autosuggestions
if [ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    skip "zsh-autosuggestions already installed"
else
    info "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    ok "Installed zsh-autosuggestions"
fi

# Powerlevel10k
if [ -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    skip "powerlevel10k already installed"
else
    info "Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
    ok "Installed Powerlevel10k"
fi

# =============================================================================
# Done
# =============================================================================
echo ""
printf "\033[1;32m✓ Dotfiles setup complete!\033[0m\n"
if [ "$BACKUP_CREATED" = true ]; then
    warn "Backups saved to $BACKUP_DIR"
fi
echo ""
info "Optional manual steps:"
echo "  • Install a Nerd Font for Powerlevel10k icons"
echo "  • Run 'source ~/.zshrc' or restart your terminal"
echo "  • Install Node.js via mise: mise install node@22"
