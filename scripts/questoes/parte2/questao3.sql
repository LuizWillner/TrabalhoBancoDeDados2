-- 3. Implementar procedimentos armazenados (stored procedures) que garantam a 
-- validação das regras semânticas criadas. Nesse caso, o mecanismo de permissões deve 
-- ser utilizado para criar um usuário que somente tenha acesso à manipulação dos dados 
-- envolvidos através do procedimento definido.


-- Procedure para verificar a data de nascimento de funcionários
CREATE OR REPLACE PROCEDURE check_employee_birthdate(p_birthdate IN DATE) IS
    v_age NUMBER;
BEGIN
    -- Verificar se a data de nascimento não é uma data futura
    check_not_future_date(p_birthdate, 'BirthDate');  -- reaproveitando a procedure criada na questão 2

    -- Verificar se o funcionário tem pelo menos 18 anos de idade
    v_age := FLOOR(MONTHS_BETWEEN(SYSDATE, p_birthdate) / 12);
    IF v_age < 18 THEN
        RAISE_APPLICATION_ERROR(-20001, 'O funcionário deve ter pelo menos 18 anos de idade.');
    END IF;
END;


-- Criação de um usuário com permissões limitadas
CREATE USER usuario_limitado IDENTIFIED BY senha;
GRANT CONNECT TO usuario_limitado;
GRANT EXECUTE ON check_employee_birthdate TO usuario_limitado;  -- Conceder permissão para executar a procedure


-- Procedure para inserir ou atualizar funcionários
CREATE OR REPLACE PROCEDURE manage_employee(
    p_employeeid IN NUMBER,
    p_lastname IN VARCHAR2,
    p_firstname IN VARCHAR2,
    p_title IN VARCHAR2,
    p_reportsto IN NUMBER,
    p_birthdate IN DATE,
    p_hiredate IN DATE,
    p_address IN VARCHAR2,
    p_city IN VARCHAR2,
    p_state IN VARCHAR2,
    p_country IN VARCHAR2,
    p_postalcode IN VARCHAR2,
    p_phone IN VARCHAR2,
    p_fax IN VARCHAR2,
    p_email IN VARCHAR2
) IS
BEGIN
    -- Verificar a data de nascimento
    check_employee_birthdate(p_birthdate);

    -- Comando MERGE utilizado para inserir ou atualizar o funcionário
    MERGE INTO employee e
    USING (SELECT p_employeeid AS employeeid FROM dual) src
    ON (e.employeeid = src.employeeid)
    WHEN MATCHED THEN
        UPDATE SET
            e.lastname = p_lastname,
            e.firstname = p_firstname,
            e.title = p_title,
            e.reportsto = p_reportsto,
            e.birthdate = p_birthdate,
            e.hiredate = p_hiredate,
            e.address = p_address,
            e.city = p_city,
            e.state = p_state,
            e.country = p_country,
            e.postalcode = p_postalcode,
            e.phone = p_phone,
            e.fax = p_fax,
            e.email = p_email
    WHEN NOT MATCHED THEN
        INSERT (
            employeeid, lastname, firstname, title, reportsto, birthdate, 
            hiredate, address, city, state, country, postalcode, phone, fax, email
        )
        VALUES (
            p_employeeid, p_lastname, p_firstname, p_title, p_reportsto, p_birthdate, 
            p_hiredate, p_address, p_city, p_state, p_country, p_postalcode, p_phone, p_fax, p_email
        );
END;

-- Conceder permissão para executar a procedure manage_employee
GRANT EXECUTE ON manage_employee TO usuario_limitado;
