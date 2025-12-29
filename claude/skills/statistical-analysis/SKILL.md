---
name: statistical-analysis
description: Análises estatísticas e testes de hipótese. Usar ao comparar grupos, testar relações, ou validar assumptions.
allowed-tools: Bash(python:*), Read
---

# Análise Estatística

## Testes Comuns

### 1. Teste de Normalidade
```python
from scipy import stats

# Shapiro-Wilk (melhor para n < 5000)
stat, p_value = stats.shapiro(data)
print(f"Shapiro-Wilk p-value: {p_value:.4f}")

if p_value > 0.05:
    print("Distribuição parece normal")
else:
    print("Distribuição NÃO é normal")
```

### 2. Comparar Dois Grupos

```python
# T-test (dados normais)
t_stat, p_value = stats.ttest_ind(grupo_a, grupo_b)
print(f"T-test p-value: {p_value:.4f}")

# Mann-Whitney U (dados não-normais)
u_stat, p_value = stats.mannwhitneyu(grupo_a, grupo_b)
print(f"Mann-Whitney p-value: {p_value:.4f}")

# Effect size (Cohen's d)
mean_diff = grupo_a.mean() - grupo_b.mean()
pooled_std = np.sqrt((grupo_a.std()**2 + grupo_b.std()**2) / 2)
cohens_d = mean_diff / pooled_std
print(f"Cohen's d: {cohens_d:.3f}")
```

### 3. Correlação

```python
# Pearson (linear)
r, p = stats.pearsonr(x, y)
print(f"Pearson r: {r:.3f}, p-value: {p:.4f}")

# Spearman (rank-based, mais robusto)
r, p = stats.spearmanr(x, y)
print(f"Spearman r: {r:.3f}, p-value: {p:.4f}")
```

### 4. ANOVA (3+ grupos)

```python
# One-way ANOVA
f_stat, p_value = stats.f_oneway(grupo1, grupo2, grupo3)
print(f"ANOVA p-value: {p_value:.4f}")
```

## Interpretação de P-values

- **p < 0.001**: Evidência muito forte
- **p < 0.01**: Evidência forte
- **p < 0.05**: Evidência significativa (threshold comum)
- **p ≥ 0.05**: Evidência insuficiente

**Importante**: p-value sozinho não basta, sempre reportar:
- Effect size
- Intervalos de confiança
- Tamanho das amostras

## Template Completo

```python
import pandas as pd
import numpy as np
from scipy import stats
import matplotlib.pyplot as plt
import seaborn as sns

# Carregar dados
df = pd.read_csv('dados.csv')

# 1. Explorar distribuições
sns.histplot(df['variavel'], kde=True)
plt.title('Distribuição da Variável')
plt.show()

# 2. Testar normalidade
stat, p = stats.shapiro(df['variavel'])
print(f"Normalidade: p={p:.4f}")

# 3. Comparar grupos
grupo_a = df[df['grupo'] == 'A']['metrica']
grupo_b = df[df['grupo'] == 'B']['metrica']

# Visualizar
sns.boxplot(data=df, x='grupo', y='metrica')
plt.show()

# Testar diferença
t_stat, p_value = stats.ttest_ind(grupo_a, grupo_b)
print(f"T-test: t={t_stat:.3f}, p={p_value:.4f}")

# Effect size
cohens_d = (grupo_a.mean() - grupo_b.mean()) / np.sqrt((grupo_a.std()**2 + grupo_b.std()**2) / 2)
print(f"Cohen's d: {cohens_d:.3f}")

# 4. Conclusão
if p_value < 0.05:
    print(f"Diferença significativa detectada (p={p_value:.4f})")
    print(f"Tamanho do efeito: {cohens_d:.3f}")
else:
    print(f"Não há evidência de diferença (p={p_value:.4f})")
```

## Checklist de Análise

- [ ] Visualizar dados primeiro
- [ ] Verificar assumptions (normalidade, homoscedasticidade)
- [ ] Escolher teste apropriado
- [ ] Reportar p-value, effect size, e CIs
- [ ] Interpretar no contexto do domínio
