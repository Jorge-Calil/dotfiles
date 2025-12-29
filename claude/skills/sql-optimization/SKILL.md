---
name: sql-optimization
description: Ajuda a escrever queries SELECT otimizadas para PostgreSQL. Usar quando precisar buscar dados do banco.
allowed-tools: Bash(psql:*), Read
---

# Queries SELECT Otimizadas

## Boas Práticas

### 1. Filtrar Cedo
```sql
-- Ruim: sem WHERE
SELECT * FROM orders;

-- Bom: filtrar primeiro
SELECT * FROM orders WHERE date >= '2024-01-01';
```

### 2. Selecionar Apenas o Necessário
```sql
-- Ruim: SELECT *
SELECT * FROM customers;

-- Bom: colunas específicas
SELECT id, name, email FROM customers;
```

### 3. Limitar Resultados em Exploração
```sql
SELECT * FROM large_table LIMIT 100;
```

### 4. Usar CTEs para Queries Complexas
```sql
WITH monthly_sales AS (
  SELECT
    DATE_TRUNC('month', date) as month,
    SUM(amount) as total
  FROM orders
  GROUP BY 1
)
SELECT * FROM monthly_sales
ORDER BY month DESC;
```

### 5. Window Functions
```sql
-- Running total
SELECT
  customer_id,
  date,
  amount,
  SUM(amount) OVER (
    PARTITION BY customer_id
    ORDER BY date
  ) as total_acumulado
FROM orders;
```

### 6. Evitar Funções em WHERE
```sql
-- Ruim: função na coluna
WHERE EXTRACT(YEAR FROM date) = 2024

-- Bom: comparação direta
WHERE date >= '2024-01-01' AND date < '2025-01-01'
```

## Template Básico

```sql
SELECT
  column1,
  column2,
  aggregate_function(column3) as alias
FROM table1
JOIN table2 ON table1.id = table2.foreign_id
WHERE condition1
  AND condition2
GROUP BY column1, column2
HAVING aggregate_condition
ORDER BY column1 DESC
LIMIT 1000;
```
