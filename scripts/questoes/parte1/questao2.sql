-- Questão 2
-- Criar usando a linguagem de programação do SGBD escolhido um procedimento que
-- remova todos os índices de uma tabela informada como parâmetro.

CREATE OR REPLACE PROCEDURE REMOVERINDICESTABELA 
(
  NOMETABELA IN VARCHAR2 
) IS     
   CURSOR cursorsVariveisDependentes IS
        SELECT c.table_name, c.constraint_name FROM user_constraints c
        WHERE  c.owner = 'CHINOOK' AND c.TABLE_NAME = NOMETABELA AND (c.constraint_type = 'R' OR c.constraint_type = 'P')
        ORDER BY c.constraint_type DESC;

BEGIN
        FOR constraintsParaRemover IN cursorsVariveisDependentes LOOP
            DBMS_OUTPUT.PUT_LINE('Constraint encontrada: ' || constraintsParaRemover.constraint_name || ' na tabela ' || constraintsParaRemover.table_name);
            EXECUTE IMMEDIATE 'ALTER TABLE ' || constraintsParaRemover.table_name || ' DROP CONSTRAINT ' || constraintsParaRemover.constraint_name;
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Index removido com sucesso');
END REMOVERINDICESTABELA;

EXEC REMOVERINDICESTABELA(NOMETABELA);
