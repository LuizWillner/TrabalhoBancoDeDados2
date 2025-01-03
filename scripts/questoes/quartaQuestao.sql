create or replace PROCEDURE CRIACAO_DINAMICA_DE_TABELAS
IS
    comandosDeCriacao VARCHAR2(1000) := '';
   	comandosDeAlteracao VARCHAR2(1000) := '';
    textoAlteracao VARCHAR(100) := '_alterado';

    CURSOR cursorTabelas IS
        SELECT TABLE_NAME 
        FROM all_tables 
        WHERE owner = 'CHINOOK';

    CURSOR cursorColunas (nomeTabela VARCHAR2) IS
        SELECT COLUMN_NAME , DATA_TYPE, DATA_LENGTH ,NULLABLE 
        FROM all_tab_columns 
        WHERE table_name = nomeTabela;

    CURSOR cursorChavesPrimarias (nomeTabela VARCHAR2) IS
        SELECT c.CONSTRAINT_NAME , c.COLUMN_NAME 
        FROM all_cons_columns  c
        JOIN user_constraints u ON u.CONSTRAINT_NAME = c.CONSTRAINT_NAME
        WHERE c.owner = 'CHINOOK' AND u.CONSTRAINT_TYPE = 'P' AND c.TABLE_NAME = nomeTabela;
    constraintPrimaryKey cursorChavesPrimarias%ROWTYPE;

    CURSOR cursorChavesEstrangeiras IS
	    SELECT tabela.CONSTRAINT_NAME AS nome_fk,
	    	   coluna.COLUMN_NAME  AS nome_coluna_fk, 
	    	   tabela.TABLE_NAME AS nome_tabela_fk,
	    	   tabela_referenciada.TABLE_NAME AS NOME_TABELA_REFERENCIADA,
	    	   coluna_referenciada.COLUMN_NAME AS nome_coluna_referenciada 
		FROM ALL_CONSTRAINTS tabela
			JOIN ALL_CONSTRAINTS tabela_referenciada ON tabela.R_CONSTRAINT_NAME = tabela_referenciada.CONSTRAINT_NAME
			JOIN ALL_CONS_COLUMNS coluna ON tabela.CONSTRAINT_NAME = coluna.CONSTRAINT_NAME
			JOIN ALL_CONS_COLUMNS coluna_referenciada ON tabela.R_CONSTRAINT_NAME = coluna_referenciada.CONSTRAINT_NAME 
		WHERE tabela.OWNER = 'CHINOOK' AND tabela.CONSTRAINT_TYPE = 'R';

BEGIN
    --Vai criando a string do comando de criação para cada tabela e para cada coluna daquela tabela
    FOR tabela IN cursorTabelas LOOP
    comandosDeCriacao := '';
    comandosDeCriacao := comandosDeCriacao || 'CREATE TABLE ' || tabela.table_name || textoAlteracao || '( ' || CHR(10);
        FOR colunasDaTabela IN cursorColunas(tabela.TABLE_NAME) LOOP
            comandosDeCriacao := comandosDeCriacao || colunasDaTabela.column_name || ' ' || colunasDaTabela.DATA_TYPE;
            IF colunasDaTabela.DATA_TYPE = 'VARCHAR2' THEN
                comandosDeCriacao := comandosDeCriacao || '(' || colunasDaTabela.DATA_LENGTH || ') ';
            END IF;
            IF colunasDaTabela.NULLABLE = 'Y' THEN
                comandosDeCriacao := comandosDeCriacao || ' , ' || CHR(10);
            ELSE 
                comandosDeCriacao := comandosDeCriacao || ' NOT NULL ,' || CHR(10);
            END IF;
        END LOOP;

        -- chave primária
	    OPEN cursorChavesPrimarias(tabela.TABLE_NAME);
	        FETCH cursorChavesPrimarias INTO constraintPrimaryKey;
	        IF cursorChavesPrimarias%FOUND THEN
	            comandosDeCriacao := comandosDeCriacao || 'CONSTRAINT ' || constraintPrimaryKey.CONSTRAINT_NAME || textoAlteracao  ||
	                                                                        ' PRIMARY KEY (' || constraintPrimaryKey.COLUMN_NAME || ')'  || CHR(10);
	        END IF;
	    CLOSE cursorChavesPrimarias;
	    comandosDeCriacao := comandosDeCriacao || ')';
        BEGIN
            DBMS_OUTPUT.PUT_LINE(comandosDeCriacao);
            EXECUTE IMMEDIATE comandosDeCriacao;
        END;

    END LOOP;
    COMMIT;

   	-- chaves estrangeiras
	FOR chaveEstrangeira IN cursorChavesEstrangeiras LOOP
		comandosDeAlteracao := '';
		comandosDeAlteracao := comandosDeAlteracao || 'ALTER TABLE ' || chaveEstrangeira.nome_tabela_fk || textoAlteracao || ' ADD CONSTRAINT '
								|| chaveEstrangeira.nome_fk || textoAlteracao ||  ' FOREIGN KEY (' || chaveEstrangeira.nome_coluna_fk || ') REFERENCES '
								|| chaveEstrangeira.nome_tabela_referenciada || textoAlteracao || ' (' || chaveEstrangeira.nome_coluna_referenciada || ')';
        BEGIN
            DBMS_OUTPUT.PUT_LINE(comandosDeAlteracao);
            EXECUTE IMMEDIATE comandosDeAlteracao;
        END;
	END LOOP;

END CRIACAO_DINAMICA_DE_TABELAS;