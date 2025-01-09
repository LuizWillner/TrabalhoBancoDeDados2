-- 2. Implementar triggers que garantam a validação das regras semânticas criadas. 



------------- Regra de Integridade de Data de Contratação de Funcionários -------------
-- A data de contratação de um funcionário (employee) não pode ser uma data futura.

-- Procedure para verificar se uma data é uma data futura
CREATE OR REPLACE PROCEDURE check_not_future_date(p_date IN DATE, p_target_column IN VARCHAR2) IS
BEGIN
    IF p_date > SYSDATE THEN
        RAISE_APPLICATION_ERROR(-20002, 'O valor de ' || p_target_column || ' não pode ser uma data futura.');
    END IF;
END;

-- Trigger para garantir Regra de Integridade de Data de Contratação de Funcionários
CREATE OR REPLACE TRIGGER trg_employee_hiredate_integrity
BEFORE INSERT OR UPDATE ON employee
FOR EACH ROW  -- indica que a trigger será executada para cada linha afetada pela operação de INSERT ou UPDATE. (tipo 'ROW')
BEGIN
     -- :NEW é uma variável especial que contém os valores dos campos da linha que está sendo inserida ou atualizada.
    check_not_future_date(:NEW.hiredate, 'HireDate');
END;


-- Exemplos de inserção em EMPLOYEE

-- Funciona!
INSERT INTO EMPLOYEE
    (EMPLOYEEID,LASTNAME,FIRSTNAME, TITLE, REPORTSTO, BIRTHDATE, HIREDATE, CITY, STATE, COUNTRY, EMAIL)
VALUES
	(
        9, 
        'Silva', 
        'João', 
        'Sales Support Agent', 
        2, 
        TO_DATE('2001-09-03 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
        TO_DATE('2020-11-17 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
        'Calgary', 
        'AB', 
        'Canada', 
        'silvajoao@email.com'
    );
    
-- Não funciona! (A data de contratação não pode ser uma data futura.)
INSERT INTO EMPLOYEE
	(EMPLOYEEID, LASTNAME, FIRSTNAME, TITLE, REPORTSTO, BIRTHDATE, HIREDATE, CITY, STATE, COUNTRY, EMAIL)
VALUES
	 (
        10, 
        'Rocha', 
        'Maria', 
        'Sales Support Agent', 
        2, 
        TO_DATE('2001-09-03 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
        TO_DATE('2032-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
        'Calgary', 
        'AB', 
        'Canada', 
        'mariarocha@email.com'
    );



------------- Regra de Integridade de Preço de Faixas -------------
-- O preço de uma faixa (track) não pode ser negativo.

-- Procedure para verificar se o número é positivo
CREATE OR REPLACE PROCEDURE check_positive_number(p_number IN NUMBER, p_target_column IN VARCHAR2) IS
BEGIN
    IF p_number < 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'O valor de ' || p_target_column || ' deve ser positivo.');
    END IF;
END;

-- Trigger para garantir Regra de Integridade de Preço de Faixa
CREATE OR REPLACE TRIGGER trg_track_price_positive
BEFORE INSERT OR UPDATE ON track
FOR EACH ROW
BEGIN
    check_positive_number(:NEW.UnitPrice, 'UnitPrice');
END;


-- Exemplo de inserção em TRACK

-- Funciona!
INSERT INTO Track 
	(TrackId, Name, AlbumId, MediaTypeId, GenreId, Composer, Milliseconds, Bytes, UnitPrice) 
VALUES 
	(10000, 'Música teste', 1, 1, 1, 'Autor fictício', 343719, 11170334, 0.99);

-- Não funciona! (O valor de UnitPrice deve ser positivo.)
INSERT INTO Track 
	(TrackId, Name, AlbumId, MediaTypeId, GenreId, Composer, Milliseconds, Bytes, UnitPrice) 
VALUES 
	(10001, 'Música teste 2', 1, 1, 1, 'Autor fictício', 343719, 11170334, -1);



------------- Regra de Integridade de Tamanho do Arquivo da Faixa -------------
-- O tamanho (em bytes) não pode ser negativo.

-- Trigger para garantir Regra de Integridade de Tamanho do Arquivo da Faixa
CREATE OR REPLACE TRIGGER trg_track_sizebytes_positive
BEFORE INSERT OR UPDATE ON track
FOR EACH ROW
BEGIN
    check_positive_number(:NEW.Bytes, 'Bytes');
END;


-- Exemplo de inserção em TRACK

-- Funciona!
INSERT INTO Track 
	(TrackId, Name, AlbumId, MediaTypeId, GenreId, Composer, Milliseconds, Bytes, UnitPrice) 
VALUES 
	(10002, 'Música teste', 1, 1, 1, 'Autor fictício', 343719, 11170334, 0.99);

-- Não funciona! (O valor de Bytes deve ser positivo.)
INSERT INTO Track 
	(TrackId, Name, AlbumId, MediaTypeId, GenreId, Composer, Milliseconds, Bytes, UnitPrice) 
VALUES 
	(10003, 'Música teste 2', 1, 1, 1, 'Autor fictício', 343719, -1, 0.99);



------------- Regra de Integridade de Duração de Faixas -------------
-- A duração de uma faixa (track) não pode ser negativa.

-- Trigger para garantir Regra de Integridade de Duração de Faixas
CREATE OR REPLACE TRIGGER trg_track_milliseconds_positive
BEFORE INSERT OR UPDATE ON track
FOR EACH ROW
BEGIN
    check_positive_number(:NEW.Milliseconds, 'Milliseconds');
END;


-- Exemplo de inserção em TRACK

-- Funciona!
INSERT INTO Track 
	(TrackId, Name, AlbumId, MediaTypeId, GenreId, Composer, Milliseconds, Bytes, UnitPrice) 
VALUES 
	(10004, 'Música teste', 1, 1, 1, 'Autor fictício', 343719, 11170334, 0.99);

-- Não funciona! (O valor de Milliseconds deve ser positivo.)
INSERT INTO Track 
	(TrackId, Name, AlbumId, MediaTypeId, GenreId, Composer, Milliseconds, Bytes, UnitPrice) 
VALUES 
	(10005, 'Música teste 2', 1, 1, 1, 'Autor fictício', -1, 11170334, 0.99);
