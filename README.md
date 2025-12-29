# Dotfiles - Data Analysis Setup

Configurações pessoais otimizadas para análise de dados com WSL2 + Arch Linux.

## Conteúdo

### Claude Code
Configurações completas do Claude Code para análise de dados:
- **CLAUDE.md**: Padrões de análise, SQL, visualização, Jupyter
- **settings.json**: Permissions, hooks, environment variables
- **Skills** (3):
  - `sql-optimization`: Queries PostgreSQL otimizadas
  - `data-profiling`: Análise de qualidade de dados
  - `statistical-analysis`: Testes estatísticos
- **Slash Commands** (3):
  - `/data-profile`: Profiling rápido de CSVs
  - `/sql-query`: Templates SQL
  - `/create-viz`: Assistente de visualização

### LazyVim
Configuração completa do Neovim com LazyVim:
- Plugins configurados
- Keybindings personalizados
- LSP configs

### Shell
- `.bashrc`: Configurações do Bash
- `.bash_profile`: Profile do Bash

## Stack Tecnológica

**Análise de Dados**:
- Python 3.11+
- pandas, numpy, matplotlib, seaborn, plotly
- pydantic (validação)
- SQLAlchemy (ORM)
- PostgreSQL

**Editor**: Neovim + LazyVim

**Terminal**: Bash

**MCP Servers**:
- PostgreSQL
- Jupyter
- Filesystem
- Sequential Thinking

## Instalação Rápida (Recomendado)

### Setup Automático com `install.sh`

O script `install.sh` automatiza **todo o processo** de instalação em um único comando:

```bash
git clone https://github.com/Jorge-Calil/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

### O que o script faz automaticamente:

**1. Sistema Base** ✓
- Instala: git, github-cli, python, pip, neovim, postgresql, base-devel
- Atualiza pacman

**2. Python** ✓
- Instala bibliotecas essenciais: pandas, numpy, matplotlib, seaborn, plotly, scipy
- Configura: pydantic, sqlalchemy, psycopg2-binary, jupyter

**3. Oh My Bash** ✓
- Instala Oh My Bash (se não instalado)
- Aplica configurações do tema "cupcake"
- Configura .bashrc e .bash_profile

**4. Git** ✓
- Configura user.name e user.email
- Define branch padrão como "main"
- Adiciona aliases úteis (st, co, br, lg)
- Configura editor padrão (nvim)

**5. GitHub CLI** ✓
- Autentica com GitHub (interativo)
- Configura acesso para push/pull

**6. Claude Code** ✓
- Instala Claude Code nativo
- Copia CLAUDE.md, settings.json, claude.json
- Instala todas as 3 skills
- Instala todos os 3 slash commands
- Faz backup de configs existentes

**7. LazyVim** ✓ (Opcional)
- Pergunta antes de instalar
- Faz backup da config existente
- Copia configuração completa
- Prepara para instalação de plugins na primeira execução

**8. MCP Servers** ✓ (Opcional)
- PostgreSQL MCP (com DSN customizável)
- Jupyter MCP (via uvx)
- Filesystem MCP
- Sequential Thinking MCP

**9. Backups** ✓
- Cria backup timestamped de todas as configs existentes
- Salva em `~/.dotfiles_backup_YYYYMMDD_HHMMSS`

### Pré-requisitos Mínimos

Apenas Git para clonar o repo:
```bash
sudo pacman -S git
```

Todo o resto é instalado pelo script!

### Setup Manual

#### 1. Claude Code
```bash
# Criar diretórios
mkdir -p ~/.claude/{commands,skills}

# Copiar configs
cp claude/CLAUDE.md ~/.claude/
cp claude/settings.json ~/.claude/
cp claude/claude.json ~/.claude.json

# Copiar skills e commands
cp -r claude/skills/* ~/.claude/skills/
cp -r claude/commands/* ~/.claude/commands/
```

#### 2. LazyVim
```bash
# Backup config existente (se houver)
mv ~/.config/nvim ~/.config/nvim.backup

# Copiar nova config
cp -r nvim ~/.config/nvim
```

#### 3. Shell
```bash
cp shell/bashrc ~/.bashrc
cp shell/bash_profile ~/.bash_profile
source ~/.bashrc
```

## MCP Servers

Configurar após instalar Claude Code:

```bash
# PostgreSQL (ajustar credenciais)
claude mcp add --transport stdio postgres -- npx -y @modelcontextprotocol/server-postgres postgresql://user:pass@localhost:5432/dbname

# Jupyter
claude mcp add --transport stdio jupyter -- /root/.local/bin/uvx ml-jupyter-mcp

# Filesystem
claude mcp add --transport stdio filesystem -- npx -y @modelcontextprotocol/server-filesystem /root

# Sequential Thinking
claude mcp add --transport stdio sequential-thinking -- npx -y @modelcontextprotocol/server-sequential-thinking
```

## Uso

### Claude Code

**Profiling de dados**:
```
> /data-profile dados.csv
```

**Query SQL**:
```
> /sql-query mostrar vendas por mês
```

**Visualização**:
```
> /create-viz scatter plot vendas vs lucro
```

**PostgreSQL direto**:
```
> Conecte ao banco e mostre os top 10 clientes
```

**Jupyter**:
```
> Crie um notebook de análise para dados.csv
```

### LazyVim

Abrir Neovim:
```bash
nvim
```

Ver plugins instalados: `:Lazy`

## Estrutura do Repositório

```
dotfiles/
├── README.md                    # Este arquivo
├── install.sh                   # Script de instalação
├── claude/                      # Claude Code configs
│   ├── CLAUDE.md
│   ├── settings.json
│   ├── claude.json
│   ├── commands/                # Slash commands
│   │   ├── data-profile.md
│   │   ├── sql-query.md
│   │   └── create-viz.md
│   └── skills/                  # Skills
│       ├── data-profiling/
│       ├── sql-optimization/
│       └── statistical-analysis/
├── nvim/                        # LazyVim config
│   ├── init.lua
│   ├── lua/
│   └── ...
└── shell/                       # Shell configs
    ├── bashrc
    └── bash_profile
```

## Atualização

Para sincronizar mudanças:

```bash
cd ~/dotfiles

# Copiar configs atuais para o repo
cp ~/.claude/CLAUDE.md claude/
cp ~/.claude/settings.json claude/
cp -r ~/.claude/skills/* claude/skills/
cp -r ~/.config/nvim/* nvim/

# Commit e push
git add .
git commit -m "Update configs"
git push
```

## Customização

### Claude Code

Edite `~/.claude/CLAUDE.md` para:
- Adicionar padrões específicos do seu domínio
- Ajustar preferências de bibliotecas
- Incluir templates de código recorrentes

### LazyVim

Edite `~/.config/nvim/lua/config/` e `~/.config/nvim/lua/plugins/`

## Licença

MIT

## Autor

Jorge - [@Jorge-Calil](https://github.com/Jorge-Calil)

---

**Stack**: Claude Code • LazyVim • PostgreSQL • Python • Jupyter
**Otimizado para**: Análise de Dados • Data Science • WSL2 + Arch Linux
