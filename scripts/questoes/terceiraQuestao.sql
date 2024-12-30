--  Questão 3
-- Consultar as tabelas de catálogo para listar todas as chaves estrangeiras existentes
-- informando as tabelas e colunas envolvidas.

SELECT c.TABLE_NAME as nome_tabela , c.COLUMN_NAME as nome_coluna FROM all_cons_columns  c
JOIN user_constraints u ON u.CONSTRAINT_NAME = c.CONSTRAINT_NAME
WHERE u.CONSTRAINT_TYPE = 'R' AND u.owner = 'CHINOOK';