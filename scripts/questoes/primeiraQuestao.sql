-- Questão 1
-- Consultar as tabelas de catálogo para listar todos os índices existentes acompanhados
-- das tabelas e colunas indexadas pelo mesmo.

Select i.index_name as nome_index, i.table_name as nome_tabela , i.column_name as nome_coluna From user_ind_columns i 
JOIN ALL_TABLES tables ON tables.table_name = i.table_name;


