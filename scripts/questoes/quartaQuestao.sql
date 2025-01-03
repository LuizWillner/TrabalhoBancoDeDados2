SELECT a.table_name, a.column_name, a.constraint_name, c.owner, 
       -- referenced pk
       c.r_owner, c_pk.table_name r_table_name, c_pk.constraint_name r_pk
  FROM all_cons_columns a
  JOIN all_constraints c ON a.owner = c.owner
                        AND a.constraint_name = c.constraint_name
  JOIN all_constraints c_pk ON c.r_owner = c_pk.owner
                           AND c.r_constraint_name = c_pk.constraint_name
 WHERE c.constraint_type = 'R'
   AND a.table_name = 'ALBUM';
   
CREATE OR REPLACE PROCEDURE CRIACAO_DINAMICA_DE_TABELAS
IS
    comandosDeCriacao VARCHAR2(1000) := '';

    CURSOR cursorTabelas IS
        SELECT TABLE_NAME 
        FROM all_tables 
        WHERE owner = 'CHINOOK';
    
    CURSOR cursorColunas (nomeTabela VARCHAR2) IS
        SELECT COLUMN_NAME , DATA_TYPE, NULLABLE 
        FROM all_tab_columns 
        WHERE table_name = nomeTabela;
        
    CURSOR cursorChavesPrimarias (nomeTabela VARCHAR2) IS
        SELECT c.CONSTRAINT_NAME , c.COLUMN_NAME 
        FROM all_cons_columns  c
        JOIN user_constraints u ON u.CONSTRAINT_NAME = c.CONSTRAINT_NAME
        WHERE c.owner = 'CHINOOK' AND u.CONSTRAINT_TYPE = 'P' AND c.TABLE_NAME = nomeTabela;
        
    constraintPrimaryKey cursorChavesPrimarias%ROWTYPE;
    
    CURSOR cursorChavesEstrangeiras (nomeTabela VARCHAR2) IS
        SELECT c.CONSTRAINT_NAME , c.COLUMN_NAME 
        FROM all_cons_columns  c
        JOIN user_constraints u ON u.CONSTRAINT_NAME = c.CONSTRAINT_NAME
        WHERE c.owner = 'CHINOOK' AND u.CONSTRAINT_TYPE = 'R' AND c.TABLE_NAME = nomeTabela;
BEGIN
    --Vai criando a string do comando de criação para cada tabela e para cada coluna daquela tabela
    FOR tabela IN cursorTabelas LOOP
    comandosDeCriacao := '';
    comandosDeCriacao := comandosDeCriacao || 'CREATE TABLE ' || tabela.table_name || '( ' || CHR(10);
        FOR colunasDaTabela IN cursorColunas(tabela.TABLE_NAME) LOOP
            comandosDeCriacao := comandosDeCriacao || colunasDaTabela.column_name || ' ' || colunasDaTabela.DATA_TYPE;
            IF colunasDaTabela.NULLABLE = 'Y' THEN
                comandosDeCriacao := comandosDeCriacao || ' , ' || CHR(10);
            ELSE 
                comandosDeCriacao := comandosDeCriacao || ' NOT NULL ,' || CHR(10);
            END IF;
        END LOOP;
        OPEN cursorChavesPrimarias(tabela.TABLE_NAME);
            FETCH cursorChavesPrimarias INTO constraintPrimaryKey;
            IF cursorChavesPrimarias%FOUND THEN
                comandosDeCriacao := comandosDeCriacao || 'CONSTRAINT ' || constraintPrimaryKey.CONSTRAINT_NAME ||
                                                                            ' PRIMARY KEY (' || constraintPrimaryKey.COLUMN_NAME || ')'  || CHR(10);
            END IF;
        CLOSE cursorChavesPrimarias;
        comandosDeCriacao := comandosDeCriacao || ');';
        DBMS_OUTPUT.PUT_LINE(comandosDeCriacao);
    END LOOP;
END CRIACAO_DINAMICA_DE_TABELAS;