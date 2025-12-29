#!/usr/bin/env python3
"""
Script de profiling de dados.

Uso:
    python profile_data.py arquivo.csv
"""

import sys
import pandas as pd
import numpy as np

def profile_dataframe(df):
    """Gera perfil completo de um DataFrame."""

    print("=" * 60)
    print("PERFIL DE DADOS")
    print("=" * 60)

    # Dimensões
    print(f"\nDimensões: {df.shape[0]:,} linhas x {df.shape[1]} colunas")
    print(f"Memória: {df.memory_usage(deep=True).sum() / 1024**2:.2f} MB")

    # Missing values
    print("\n" + "=" * 60)
    print("VALORES AUSENTES")
    print("=" * 60)
    missing = df.isnull().sum()
    missing_pct = (missing / len(df) * 100).round(2)
    missing_df = pd.DataFrame({
        'Count': missing,
        'Percent': missing_pct
    })
    missing_filtered = missing_df[missing_df['Count'] > 0]
    if len(missing_filtered) > 0:
        print(missing_filtered)
    else:
        print("Nenhum valor ausente encontrado!")

    # Duplicatas
    print("\n" + "=" * 60)
    print("DUPLICATAS")
    print("=" * 60)
    duplicates = df.duplicated().sum()
    dup_pct = (duplicates / len(df) * 100).round(2) if len(df) > 0 else 0
    print(f"Linhas duplicadas: {duplicates:,} ({dup_pct}%)")

    # Tipos de dados
    print("\n" + "=" * 60)
    print("TIPOS DE DADOS")
    print("=" * 60)
    print(df.dtypes.value_counts())

    # Estatísticas numéricas
    numeric_cols = df.select_dtypes(include=[np.number]).columns
    if len(numeric_cols) > 0:
        print("\n" + "=" * 60)
        print("ESTATÍSTICAS NUMÉRICAS")
        print("=" * 60)
        print(df[numeric_cols].describe())

        # Outliers
        print("\n" + "=" * 60)
        print("OUTLIERS (Método IQR)")
        print("=" * 60)
        outliers_found = False
        for col in numeric_cols:
            Q1 = df[col].quantile(0.25)
            Q3 = df[col].quantile(0.75)
            IQR = Q3 - Q1
            if IQR == 0:
                continue
            lower = Q1 - 1.5 * IQR
            upper = Q3 + 1.5 * IQR
            outliers = ((df[col] < lower) | (df[col] > upper)).sum()
            if outliers > 0:
                outliers_found = True
                pct = (outliers / len(df) * 100).round(2)
                print(f"{col}: {outliers:,} outliers ({pct}%)")

        if not outliers_found:
            print("Nenhum outlier detectado!")

    # Colunas categóricas
    cat_cols = df.select_dtypes(include=['object', 'category']).columns
    if len(cat_cols) > 0:
        print("\n" + "=" * 60)
        print("COLUNAS CATEGÓRICAS")
        print("=" * 60)
        for col in cat_cols:
            unique_count = df[col].nunique()
            print(f"\n{col}:")
            print(f"  Valores únicos: {unique_count}")
            if unique_count <= 10:
                print(f"  Distribuição:")
                print(df[col].value_counts().head(10))

    print("\n" + "=" * 60)

def main():
    if len(sys.argv) < 2:
        print("Uso: python profile_data.py arquivo.csv")
        sys.exit(1)

    filepath = sys.argv[1]

    try:
        # Tentar ler CSV
        df = pd.read_csv(filepath)
    except FileNotFoundError:
        print(f"Erro: Arquivo '{filepath}' não encontrado.")
        sys.exit(1)
    except Exception as e:
        print(f"Erro ao ler arquivo: {e}")
        sys.exit(1)

    profile_dataframe(df)

if __name__ == "__main__":
    main()
