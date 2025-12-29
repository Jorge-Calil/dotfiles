---
description: Cria visualizações de dados com matplotlib/seaborn/plotly
argument-hint: [tipo de gráfico] [descrição]
allowed-tools: Bash(python:*)
---

# Criar Visualização

Vou criar uma visualização: **$ARGUMENTS**

## Seletor de Gráficos

**Distribuição**:
- Histogram: Ver shape da distribuição
- Boxplot: Identificar outliers e quartis
- Violin plot: Distribuição + densidade

**Relações**:
- Scatter plot: Correlação entre variáveis
- Heatmap: Matriz de correlação
- Line plot: Tendências ao longo do tempo

**Comparações**:
- Bar chart: Comparar categorias
- Boxplot: Comparar distribuições entre grupos

## Template Seaborn (Estático)

```python
import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd

# Configuração
sns.set_style('whitegrid')
plt.figure(figsize=(10, 6))

# Carregar dados
df = pd.read_csv('dados.csv')

# Criar gráfico (escolha um):

# Histogram
sns.histplot(data=df, x='variavel', kde=True)

# Boxplot
sns.boxplot(data=df, x='categoria', y='valor')

# Scatter
sns.scatterplot(data=df, x='var1', y='var2', hue='grupo')

# Heatmap (correlação)
sns.heatmap(df.corr(), annot=True, cmap='coolwarm', center=0)

# Line plot
sns.lineplot(data=df, x='data', y='valor')

# Personalização
plt.title('Título do Gráfico')
plt.xlabel('Label X com Unidade')
plt.ylabel('Label Y com Unidade')
plt.tight_layout()

# Salvar
plt.savefig('grafico.png', dpi=150, bbox_inches='tight')
plt.show()
```

## Template Plotly (Interativo)

```python
import plotly.express as px
import pandas as pd

df = pd.read_csv('dados.csv')

# Scatter interativo
fig = px.scatter(df, x='var1', y='var2', color='grupo',
                 title='Título', hover_data=['info_extra'])

# Line interativo
fig = px.line(df, x='data', y='valor', title='Tendência')

# Box interativo
fig = px.box(df, x='categoria', y='valor', title='Comparação')

fig.show()
```
