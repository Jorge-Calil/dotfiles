---
name: data-profiling
description: Analisa qualidade de dados e gera perfil estatístico. Usar ao explorar novos datasets ou validar dados.
allowed-tools: Bash(python:*), Read
---

# Análise de Qualidade de Dados

## O que é Profiling?

Gera análise completa de:
- Tipos de dados
- Valores ausentes (missing)
- Duplicatas
- Outliers
- Estatísticas descritivas
- Correlações

## Uso Rápido

```python
import pandas as pd
import numpy as np

df = pd.read_csv('dados.csv')

# Info geral
print("=" * 50)
print(f"SHAPE: {df.shape[0]} linhas x {df.shape[1]} colunas")
print("=" * 50)

# Missing values
print("\nMISSING VALUES:")
missing = df.isnull().sum()
missing_pct = (missing / len(df) * 100).round(2)
missing_df = pd.DataFrame({
    'Count': missing,
    'Percent': missing_pct
})
print(missing_df[missing_df['Count'] > 0])

# Duplicatas
duplicates = df.duplicated().sum()
print(f"\nDUPLICATAS: {duplicates} linhas ({duplicates/len(df)*100:.2f}%)")

# Tipos
print("\nTIPOS DE DADOS:")
print(df.dtypes.value_counts())

# Estatísticas numéricas
print("\nESTATÍSTICAS NUMÉRICAS:")
print(df.describe())

# Outliers (IQR method)
print("\nOUTLIERS (método IQR):")
numeric_cols = df.select_dtypes(include=[np.number]).columns
for col in numeric_cols:
    Q1 = df[col].quantile(0.25)
    Q3 = df[col].quantile(0.75)
    IQR = Q3 - Q1
    outliers = ((df[col] < Q1 - 1.5*IQR) | (df[col] > Q3 + 1.5*IQR)).sum()
    if outliers > 0:
        print(f"  {col}: {outliers} outliers ({outliers/len(df)*100:.2f}%)")
```

## Script Completo

Ver `scripts/profile_data.py` para script standalone que pode rodar:

```bash
python ~/.claude/skills/data-profiling/scripts/profile_data.py arquivo.csv
```
