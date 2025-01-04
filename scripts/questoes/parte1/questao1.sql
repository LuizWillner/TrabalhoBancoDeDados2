-- Questão 1
-- Consultar as tabelas de catálogo para listar todos os índices existentes acompanhados
-- das tabelas e colunas indexadas pelo mesmo.

SELECT i.index_name AS nome_index, i.table_name AS nome_tabela , i.column_name AS nome_coluna FROM user_ind_columns i 
JOIN ALL_TABLES tables ON tables.table_name = i.table_name;


