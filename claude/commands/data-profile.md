---
description: Analisa qualidade de dados de um arquivo CSV
argument-hint: <arquivo.csv>
allowed-tools: Bash(python:*)
---

# Análise de Qualidade de Dados

Vou analisar o arquivo: **$ARGUMENTS**

Rodando análise completa de qualidade...

```python
import pandas as pd
import numpy as np

# Carregar dados
df = pd.read_csv("$ARGUMENTS")

print("=" * 60)
print("PERFIL DE DADOS")
print("=" * 60)

# Dimensões
print(f"\nDimensões: {df.shape[0]:,} linhas x {df.shape[1]} colunas")

# Missing values
print("\nVALORES AUSENTES:")
missing = df.isnull().sum()
missing_pct = (missing / len(df) * 100).round(2)
for col in df.columns:
    if missing[col] > 0:
        print(f"  {col}: {missing[col]} ({missing_pct[col]}%)")

# Duplicatas
duplicates = df.duplicated().sum()
print(f"\nDUPLICATAS: {duplicates} ({duplicates/len(df)*100:.2f}%)")

# Tipos
print("\nTIPOS DE DADOS:")
print(df.dtypes.value_counts())

# Estatísticas numéricas
print("\nESTATÍSTICAS NUMÉRICAS:")
print(df.describe())

# Outliers
print("\nOUTLIERS (método IQR):")
numeric_cols = df.select_dtypes(include=[np.number]).columns
for col in numeric_cols:
    Q1 = df[col].quantile(0.25)
    Q3 = df[col].quantile(0.75)
    IQR = Q3 - Q1
    if IQR > 0:
        outliers = ((df[col] < Q1 - 1.5*IQR) | (df[col] > Q3 + 1.5*IQR)).sum()
        if outliers > 0:
            print(f"  {col}: {outliers} outliers ({outliers/len(df)*100:.2f}%)")

print("=" * 60)
```
