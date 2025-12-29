#!/bin/bash
set -e

echo "============================================"
echo "  Dotfiles - Instalação Ultra Completa"
echo "  Data Analysis Setup para WSL2 + Arch"
echo "============================================"
echo

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[✓]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[!]${NC} $1"; }
log_error() { echo -e "${RED}[✗]${NC} $1"; }
log_step() { echo -e "${BLUE}[→]${NC} $1"; }

# Verificar diretório
if [ ! -f "README.md" ] || [ ! -d "claude" ]; then
    log_error "Execute do diretório ~/dotfiles"
    exit 1
fi

BACKUP_DIR=~/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)
mkdir -p "$BACKUP_DIR"
log_info "Backups serão salvos em: $BACKUP_DIR"
echo

# ============================================
# 1. SISTEMA BASE
# ============================================
echo
log_step "PASSO 1: Instalando pacotes do sistema..."
echo

# Pacman packages
PACKAGES=(
    "git"
    "github-cli"
    "python"
    "python-pip"
    "neovim"
    "postgresql"
    "base-devel"
)

log_info "Instalando pacotes via pacman..."
sudo pacman -Sy --needed --noconfirm "${PACKAGES[@]}"

log_info "Pacotes do sistema instalados!"

# ============================================
# 2. PYTHON
# ============================================
echo
log_step "PASSO 2: Configurando Python..."
echo

log_info "Instalando bibliotecas Python essenciais..."
pip install --user --quiet pandas numpy matplotlib seaborn plotly scipy pydantic sqlalchemy psycopg2-binary jupyter

log_info "Python configurado!"

# ============================================
# 3. OH MY BASH
# ============================================
echo
log_step "PASSO 3: Configurando Oh My Bash..."
echo

if [ ! -d ~/.oh-my-bash ]; then
    log_info "Instalando Oh My Bash..."
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)" --unattended
else
    log_warn "Oh My Bash já instalado"
fi

# Aplicar bashrc
if [ -f ~/.bashrc ]; then
    cp ~/.bashrc "$BACKUP_DIR/bashrc"
fi
cp shell/bashrc ~/.bashrc

if [ -f shell/bash_profile ]; then
    cp shell/bash_profile ~/.bash_profile
fi

log_info "Oh My Bash configurado!"

# ============================================
# 4. GIT
# ============================================
echo
log_step "PASSO 4: Configurando Git..."
echo

if [ ! -f ~/.gitconfig ]; then
    read -p "Seu nome (Git): " git_name
    read -p "Seu email (Git): " git_email

    git config --global user.name "$git_name"
    git config --global user.email "$git_email"
    git config --global init.defaultBranch main
    git config --global core.editor nvim
    git config --global push.autoSetupRemote true

    # Aliases úteis
    git config --global alias.st status
    git config --global alias.co checkout
    git config --global alias.br branch
    git config --global alias.ci commit
    git config --global alias.lg "log --oneline --graph --decorate --all"

    log_info "Git configurado!"
else
    log_warn "Git já configurado (~/.gitconfig existe)"
fi

# GitHub CLI
if ! gh auth status &>/dev/null; then
    echo
    log_warn "GitHub CLI não autenticado"
    read -p "Autenticar GitHub CLI agora? [y/N]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        gh auth login
    fi
fi

# ============================================
# 5. CLAUDE CODE
# ============================================
echo
log_step "PASSO 5: Instalando Claude Code..."
echo

if ! command -v claude &>/dev/null; then
    log_info "Instalando Claude Code..."
    curl -fsSL https://claude.ai/install.sh | sh

    # Adicionar ao PATH se necessário
    if ! command -v claude &>/dev/null; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    fi
else
    log_warn "Claude Code já instalado"
fi

# Configurar Claude Code
log_info "Configurando Claude Code..."

# Backup
if [ -f ~/.claude/CLAUDE.md ]; then
    cp ~/.claude/CLAUDE.md "$BACKUP_DIR/CLAUDE.md"
fi
if [ -f ~/.claude/settings.json ]; then
    cp ~/.claude/settings.json "$BACKUP_DIR/settings.json"
fi

# Criar estrutura
mkdir -p ~/.claude/{commands,skills}

# Copiar configs
cp claude/CLAUDE.md ~/.claude/
cp claude/settings.json ~/.claude/
cp claude/claude.json ~/.claude.json

# Copiar skills e commands
cp -r claude/skills/* ~/.claude/skills/
cp -r claude/commands/* ~/.claude/commands/

log_info "Claude Code configurado!"

# ============================================
# 6. LAZYVIM
# ============================================
echo
log_step "PASSO 6: Configurando LazyVim..."
echo

read -p "Instalar LazyVim? (sobrescreverá ~/.config/nvim) [y/N]: " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [ -d ~/.config/nvim ]; then
        mv ~/.config/nvim "$BACKUP_DIR/nvim"
        log_warn "Backup de nvim salvo em $BACKUP_DIR/nvim"
    fi

    mkdir -p ~/.config
    cp -r nvim ~/.config/nvim

    log_info "LazyVim configurado!"
    log_warn "Na primeira execução, nvim instalará os plugins automaticamente"
else
    log_info "LazyVim: Pulado"
fi

# ============================================
# 7. VSCODE (WSL)
# ============================================
echo
log_step "PASSO 7: VSCode Settings (opcional)..."
echo

VSCODE_WIN="/mnt/c/Users/estel/AppData/Roaming/Code/User/settings.json"
if [ -f "$VSCODE_WIN" ]; then
    read -p "Sincronizar VSCode settings? [y/N]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        log_warn "VSCode settings está vazio no repo"
        log_info "Para adicionar: copie manualmente suas configs para vscode/settings.json"
    fi
else
    log_warn "VSCode não encontrado"
fi

# ============================================
# 8. MCP SERVERS
# ============================================
echo
log_step "PASSO 8: Configurando MCP Servers..."
echo

log_info "Verificando MCP servers instalados..."
claude mcp list || true

echo
read -p "Configurar MCP servers? [y/N]: " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo
    log_info "Configurando MCP servers essenciais..."

    # PostgreSQL
    read -p "Configurar PostgreSQL MCP? [y/N]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        read -p "PostgreSQL DSN (ex: postgresql://user:pass@localhost:5432/db): " pg_dsn
        claude mcp add --transport stdio postgres -- npx -y @modelcontextprotocol/server-postgres "$pg_dsn" || true
        log_info "PostgreSQL MCP adicionado"
    fi

    # Jupyter
    read -p "Configurar Jupyter MCP? [y/N]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Instalar uvx se necessário
        if ! command -v uvx &>/dev/null; then
            log_info "Instalando uv..."
            curl -LsSf https://astral.sh/uv/install.sh | sh
        fi

        claude mcp add --transport stdio jupyter -- /root/.local/bin/uvx ml-jupyter-mcp || true
        log_info "Jupyter MCP adicionado"
    fi

    # Filesystem
    claude mcp add --transport stdio filesystem -- npx -y @modelcontextprotocol/server-filesystem /root || true
    log_info "Filesystem MCP adicionado"

    # Sequential Thinking
    claude mcp add --transport stdio sequential-thinking -- npx -y @modelcontextprotocol/server-sequential-thinking || true
    log_info "Sequential Thinking MCP adicionado"

else
    log_warn "MCP servers: Configuração manual necessária (ver README.md)"
fi

# ============================================
# 9. FINALIZACAO
# ============================================
echo
echo "============================================"
log_info "Instalação Concluída!"
echo "============================================"
echo

echo "📦 Instalado:"
echo "  ✓ Git + GitHub CLI"
echo "  ✓ Python 3.13 + bibliotecas de dados"
echo "  ✓ Oh My Bash"
echo "  ✓ Claude Code + configs"
echo "  ✓ LazyVim (se selecionado)"
echo "  ✓ MCP Servers (se configurados)"
echo

echo "📝 Próximos Passos:"
echo

echo "1. Reinicie o terminal (ou: source ~/.bashrc)"
echo

echo "2. Teste Claude Code:"
echo "   $ claude"
echo "   > /data-profile test.csv"
echo

echo "3. Configure LazyVim (primeira execução):"
echo "   $ nvim"
echo "   (aguarde instalação dos plugins)"
echo

echo "4. Ajuste credenciais do PostgreSQL:"
echo "   Edite ~/.claude.json se necessário"
echo

echo "5. Adicione VSCode settings ao repo:"
echo "   Copie suas configs para vscode/settings.json"
echo

log_info "Backups salvos em: $BACKUP_DIR"
log_info "Documentação completa: README.md"
echo
log_info "Divirta-se analisando dados! 🚀"
