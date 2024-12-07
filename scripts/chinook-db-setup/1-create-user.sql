-- Executar o script abaixo na conexão padrão do superusuário "system"

ALTER SESSION SET container=XEpdb1;  -- altera o container para o XEPDB1

CREATE USER chinook IDENTIFIED BY senha container=current;  -- usuário chinook criado com senha "senha"

GRANT connect TO chinook;
GRANT resource TO chinook;
GRANT create session TO chinook;
GRANT create table TO chinook;
GRANT create view TO chinook;
GRANT create sequence TO chinook;
grant UNLIMITED TABLESPACE to developer; -- concede ao usuário developer o privilégio 
-- de usar qualquer quantidade de espaço em disco em todos os tablespaces disponíveis no banco de dados.

-- Adicionar conexão ao banco de dados com usuário "chinook", senha "senha" e nome do serviço "XEPDB1" 
-- no SQLDeveloper ou DBeaver