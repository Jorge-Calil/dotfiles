# Padrões de Análise de Dados

## Ambiente e Ferramentas

**Stack Python**
- Python 3.11+
- Bibliotecas principais: pandas, numpy, matplotlib, seaborn, plotly
- Validação de dados: pydantic
- ORM: SQLAlchemy
- Database: PostgreSQL

**Jupyter Notebooks**
- Formato preferido para análises exploratórias
- Estrutura padrão: imports → load → explore → clean → analyze → visualize

---

## Workflow de Análise

### Exploração Inicial
```python
# Sempre começar com:
df.info()                    # tipos, nulls
df.describe()                # estatísticas
df.isnull().sum()            # missing values
df.duplicated().sum()        # duplicatas
```

### Validação de Dados
- Usar **pydantic** para validar schemas de dados
- Verificar tipos, ranges, formatos
- Documentar assumptions e limitações

```python
from pydantic import BaseModel, validator

class SalesRecord(BaseModel):
    customer_id: int
    amount: float
    date: str

    @validator('amount')
    def amount_must_be_positive(cls, v):
        if v <= 0:
            raise ValueError('amount deve ser positivo')
        return v
```

### Limpeza
- Manter dados originais intactos
- Criar novas colunas para transformações
- Documentar cada passo de limpeza
- Logar registros removidos

---

## Visualização

### Escolha de Gráficos
- **Distribuição**: histogram, boxplot
- **Relação**: scatter, heatmap
- **Comparação**: barplot, boxplot
- **Tendência temporal**: lineplot

### Preferências
- **Estático**: seaborn (padrão)
- **Interativo**: plotly
- Sempre incluir: título, labels, unidades
- Export: `plt.savefig('file.png', dpi=150, bbox_inches='tight')`

### Acessibilidade
- Paletas colorblind-friendly
- Não depender apenas de cor
- Legendas claras

---

## SQL e PostgreSQL

### Boas Práticas
```sql
-- Sempre usar EXPLAIN ANALYZE
EXPLAIN ANALYZE
SELECT column1, column2
FROM table
WHERE date >= '2024-01-01'
LIMIT 100;

-- Preferir window functions
SELECT
  customer_id,
  SUM(amount) OVER (PARTITION BY customer_id ORDER BY date) as running_total
FROM orders;

-- CTEs para queries complexas
WITH monthly_sales AS (
  SELECT DATE_TRUNC('month', date) as month, SUM(amount) as total
  FROM orders
  GROUP BY 1
)
SELECT * FROM monthly_sales;
```

### Otimização
- Filtrar cedo (WHERE antes de JOIN)
- Selecionar apenas colunas necessárias
- Indexar colunas usadas em WHERE/JOIN
- Evitar funções em colunas indexadas

### SQLAlchemy
```python
from sqlalchemy import create_engine
from sqlalchemy.orm import Session

engine = create_engine('postgresql://user:pass@localhost/db')

# Query com pandas
df = pd.read_sql('SELECT * FROM table', engine)

# ORM para inserts/updates
with Session(engine) as session:
    result = session.execute('SELECT * FROM users WHERE id = :id', {'id': 123})
```

---

## Pandas - Operações Comuns

### Datas
```python
df = pd.read_csv('data.csv', parse_dates=['date'])
df['year'] = df['date'].dt.year
df['month'] = df['date'].dt.month
```

### Missing Values
```python
# Estratégias por tipo
df['numeric_col'].fillna(df['numeric_col'].median())
df['category'].fillna('Desconhecido')

# Ou remover se >30% missing
df.dropna(subset=['critical_column'])
```

### Outliers (IQR)
```python
Q1 = df['amount'].quantile(0.25)
Q3 = df['amount'].quantile(0.75)
IQR = Q3 - Q1

outliers = df[(df['amount'] < Q1 - 1.5*IQR) | (df['amount'] > Q3 + 1.5*IQR)]
# Revisar antes de remover - contexto importa
```

### Performance
```python
# Categoricals para strings repetidas
df['category'] = df['category'].astype('category')

# Vetorizar (evitar loops)
df['total'] = df['price'] * df['quantity']  # ✓
# for idx, row in df.iterrows(): ...  # ✗

# Ler apenas colunas necessárias
df = pd.read_csv('file.csv', usecols=['col1', 'col2'])
```

---

## Análise Estatística

### Testes de Hipótese
Sempre reportar:
- Estatística do teste + p-value
- Effect size (Cohen's d, etc)
- Intervalo de confiança (95%)
- Tamanho das amostras

```python
from scipy import stats

# T-test
t_stat, p_value = stats.ttest_ind(group_a, group_b)

# Cohen's d
pooled_std = np.sqrt((group_a.std()**2 + group_b.std()**2) / 2)
cohens_d = (group_a.mean() - group_b.mean()) / pooled_std
```

### Correlação
```python
# Visualizar primeiro
sns.scatterplot(data=df, x='var1', y='var2')

# Pearson (linear) ou Spearman (rank-based)
r, p = stats.pearsonr(df['x'], df['y'])
```

---

## Jupyter - Estrutura de Notebook

```markdown
# Título da Análise

## Objetivo
Qual pergunta estamos respondendo?

## Fonte dos Dados
De onde vêm os dados?

## Metodologia
Como abordamos a análise?

## Principais Descobertas
- Achado 1
- Achado 2

## Limitações
Quais são os caveats?
```

```python
# Cell 1: Imports
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

pd.set_option('display.max_columns', None)
sns.set_style('whitegrid')
%matplotlib inline

# Cell 2: Load
df = pd.read_csv('data.csv')

# Cell 3: Explore
df.info()
```

---

## Qualidade de Código

### Docstrings
```python
def calculate_metric(customer_id: int, start_date: str) -> float:
    """
    Calcula métrica para cliente em período.

    Args:
        customer_id: ID único do cliente
        start_date: Data inicial (YYYY-MM-DD)

    Returns:
        Valor da métrica como float
    """
    pass
```

### Type Hints
```python
from typing import List, Dict, Optional

def process_data(df: pd.DataFrame, columns: List[str]) -> pd.DataFrame:
    """Processa dataframe."""
    return df[columns]
```

---

## Comandos Úteis

- `/data-profile <arquivo>`: Análise de qualidade de dados
- `/sql-query`: Ajuda com queries PostgreSQL otimizadas
- `/create-viz`: Sugestões de visualização

---

## Lembrar Sempre

- Qualidade de dados primeiro
- Validar assumptions estatisticamente
- Visualizar antes e depois de transformações
- Documentar raciocínio e decisões
- Reprodutibilidade é essencial
- Significância estatística ≠ significância prática
- Correlação ≠ causalidade
