---
description: Ajuda a escrever uma query PostgreSQL otimizada
argument-hint: [descrição do que você precisa]
allowed-tools: Bash(psql:*)
---

# Query SQL Otimizada

Vou ajudar a criar uma query para: **$ARGUMENTS**

## Template Otimizado

```sql
-- Query otimizada para: $ARGUMENTS

SELECT
  -- Selecione apenas colunas necessárias (evite SELECT *)
  coluna1,
  coluna2,
  AGG_FUNCTION(coluna3) as alias
FROM tabela_principal
-- JOINs (se necessário)
JOIN tabela2 ON tabela_principal.id = tabela2.foreign_id
-- Filtros (aplicar o mais cedo possível)
WHERE condicao1
  AND condicao2
  -- Evite funções em colunas indexadas:
  -- Ruim: WHERE EXTRACT(YEAR FROM data) = 2024
  -- Bom: WHERE data >= '2024-01-01' AND data < '2025-01-01'
-- Agrupamento (se necessário)
GROUP BY coluna1, coluna2
HAVING condicao_agregada
-- Ordenação
ORDER BY coluna1 DESC
-- Limite para exploração
LIMIT 1000;
```

## Dicas

1. **Filtrar cedo**: WHERE antes de JOIN quando possível
2. **Colunas específicas**: Evite SELECT *
3. **Evite funções em WHERE**: Use comparações diretas
4. **Use CTEs** para queries complexas:

```sql
WITH dados_filtrados AS (
  SELECT * FROM tabela WHERE condicao
)
SELECT * FROM dados_filtrados;
```

5. **Window functions** para cálculos avançados:

```sql
SELECT
  coluna,
  SUM(valor) OVER (PARTITION BY grupo ORDER BY data) as total_acumulado
FROM tabela;
```
