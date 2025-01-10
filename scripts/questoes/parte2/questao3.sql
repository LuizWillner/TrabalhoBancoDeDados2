-- 3. Implementar procedimentos armazenados (stored procedures) que garantam a 
-- validação das regras semânticas criadas. Nesse caso, o mecanismo de permissões deve 
-- ser utilizado para criar um usuário que somente tenha acesso à manipulação dos dados 
-- envolvidos através do procedimento definido.


-- Procedure para verificar a data de nascimento de funcionários
CREATE OR REPLACE PROCEDURE check_employee_birthdate(p_birthdate IN employee.birthdate%TYPE) IS
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
CREATE USER usuario_de_acesso IDENTIFIED BY senha;
GRANT CONNECT TO usuario_de_acesso;
GRANT EXECUTE ON check_employee_birthdate TO usuario_de_acesso;  -- Conceder permissão para executar a procedure


-- Procedure para inserir ou atualizar funcionários
CREATE OR REPLACE PROCEDURE manage_employee(
    p_employeeid IN employee.employeeid%TYPE,
    p_lastname IN employee.lastname%TYPE,
    p_firstname IN employee.firstname%TYPE,
    p_title IN employee.title%TYPE,
    p_reportsto IN employee.reportsto%TYPE,
    p_birthdate IN employee.birthdate%TYPE,
    p_hiredate IN employee.hiredate%TYPE,
    p_address IN employee.address%TYPE,
    p_city IN employee.city%TYPE,
    p_state IN employee.state%TYPE,
    p_country IN employee.country%TYPE,
    p_postalcode IN employee.postalcode%TYPE,
    p_phone IN employee.phone%TYPE,
    p_fax IN employee.fax%TYPE,
    p_email IN employee.email%TYPE
) IS
BEGIN
    -- Verificar a data de nascimento
    check_employee_birthdate(p_birthdate);
    
     -- reaproveitando a procedure criada na questão 2. Redundante se considerar que já existe trigger pra isso definida na questão 2
    check_not_future_date(p_hiredate, 'HireDate');

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
GRANT EXECUTE ON manage_employee TO usuario_de_acesso;

-- Numa conexão com usuario_de_acesso, podemos executar a procedure manage_employee:
BEGIN
    manage_employee(
        100, 'Silva', 'João', 'Sales Support Agent', 1, 
        TO_DATE('2001-09-03 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), -- Se trocar a data de nascimento para uma data futura ou menor que 18 anos, a procedure irá falhar
        TO_DATE('2020-10-03 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), -- Se trocar a data de contratação para uma data futura, a procedure irá falhar
        'Rua dos Bobos, 0', 'Calgary', 'AB', 'Canada', 'T2P 2T3', '+1 (403) 000-0000', '+1 (403) 000-0001', 'silvajoao@email.com');
END;

