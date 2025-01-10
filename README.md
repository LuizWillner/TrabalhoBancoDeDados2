# Trabalho PL/SQL - Banco de Dados II

Trabalho da disciplina de Banco de Dados II | prof. Rodrigo Salvador | 2024.2 | Universidade Federal Fluminense

## Enunciado do trabalho

O enunciado do trabalho se encontra no arquivo [trabalho-bd2-2024-2.pdf](https://github.com/LuizWillner/TrabalhoBancoDeDados2/blob/main/trabalho-bd2-2024-2.pdf).

## Participantes do trabalho

- Gabriel Vieira Alves
- Leon Rabello
- Luiz Claudio Willner
- Marina Savino Rocha Piragibe Magalhães
- Pedro Henrique Bose Ximenes Pedrosa

## Banco de dados Chinook

Chinook é um banco de dados de exemplo disponível para SQL Server, Oracle, MySQL, etc. O modelo de dados do Chinook representa uma loja de mídia digital, incluindo tabelas para artistas, álbuns, faixas de mídia, faturas e clientes. Os dados relacionados à mídia foram criados usando dados reais de uma biblioteca do iTunes. É possível usar sua própria biblioteca do iTunes para gerar os scripts SQL, veja as instruções aqui. As informações de clientes e funcionários foram criadas manualmente usando nomes fictícios, endereços que podem ser localizados no Google Maps e outros dados bem formatados (telefone, fax, e-mail, etc.). As informações de vendas são geradas automaticamente usando dados aleatórios para um período de quatro anos.

Nesse trabalho, o SGBD escolhido para gerenciar os dados foi o **Oracle** (versão _Oracle Database 21c Express Edition version 21.3.0.0.0_).

## Setup do banco de dados Chinook

O código para setup do banco foi extraído do repositório [ChinookDatabase de cwoodruff](https://github.com/cwoodruff/ChinookDatabase/blob/master/Scripts/Chinook_Oracle.sql) para Oracle. Siga os passos para configurar:

1. Baixe e instale o [Oracle Database 21c Express Edition](https://www.oracle.com/br/database/technologies/xe-downloads.html).

2. Durante a instalação, defina e guarde a senha do super usuário "system" do Banco de Dados.

3. Baixe e instale o [SQL Developer](https://www.oracle.com/database/sqldeveloper/technologies/download/) ou alguma outra ferramenta de administração e visualização de banco de dados, como o [DBeaver](https://dbeaver.io/download/).

4. Após a instalação, crie uma conexão com o Banco de Dados Oracle pelo SQL Developer ou DBeaver utilizando o super usuário "system" e a senha definida.

5. O diretório [scripts/chinook-db-setup/](https://github.com/LuizWillner/TrabalhoBancoDeDados2/tree/main/scripts/chinook-db-setup) do projeto contém os scripts em SQL para fazer a criação e população das tabelas do chinook. Execute-os na ordem definida.

   1. [01-create-user.sql](https://github.com/LuizWillner/TrabalhoBancoDeDados2/blob/main/scripts/chinook-db-setup/01-create-user.sql): Execute esse script na conexão padrão do superusuário "system". O script cria um novo usuário "chinook", com senha "senha" (altere caso desejado), com as devidas permissões que será dono do esquema que conterá as tabelas e outros objetos do banco de dados Chinook.

   2. [02-create-tables.sql](https://github.com/LuizWillner/TrabalhoBancoDeDados2/blob/main/scripts/chinook-db-setup/02-create-tables.sql): Antes de executar esse script, crie uma nova conexão com o banco de dados, agora utilizando o user "chinook" com a senha definida e service name "XEpdb1" (container onde está o usuário "chinook"). **Execute o script nessa nova conexão**. Ele criará as tabelas a serem populadas.

   3. [03-alter-tables.sql](https://github.com/LuizWillner/TrabalhoBancoDeDados2/blob/main/scripts/chinook-db-setup/03-alter-tables.sql): Execute o script conectado na sessão com user "chinook" e service name "XEpdb1". Ele faz a inserção das restrições de foreign keys das tabelas.

   4. [04-insert-into-genre.sql](https://github.com/LuizWillner/TrabalhoBancoDeDados2/blob/main/scripts/chinook-db-setup/04-insert-into-genre.sql): Execute o script conectado na sessão com user "chinook" e service name "XEpdb1". Popula a tabela Genre.

   5. [05-insert-into-mediatype.sql](https://github.com/LuizWillner/TrabalhoBancoDeDados2/blob/main/scripts/chinook-db-setup/05-insert-into-mediatype.sql): Execute o script conectado na sessão com user "chinook" e service name "XEpdb1". Popula a tabela MediaType.

   6. [06-insert-into-artist.sql](https://github.com/LuizWillner/TrabalhoBancoDeDados2/blob/main/scripts/chinook-db-setup/06-insert-into-artist.sql): Execute o script conectado na sessão com user "chinook" e service name "XEpdb1". Popula a tabela Artist.

   7. [07-insert-into-album.sql](https://github.com/LuizWillner/TrabalhoBancoDeDados2/blob/main/scripts/chinook-db-setup/07-insert-into-album.sql): Execute o script conectado na sessão com user "chinook" e service name "XEpdb1". Popula a tabela Album.

   8. [08-insert-into-track.sql](https://github.com/LuizWillner/TrabalhoBancoDeDados2/blob/main/scripts/chinook-db-setup/08-insert-into-track.sql): Execute o script conectado na sessão com user "chinook" e service name "XEpdb1". Popula a tabela Track.

   9. [09-insert-into-employee.sql](https://github.com/LuizWillner/TrabalhoBancoDeDados2/blob/main/scripts/chinook-db-setup/09-insert-into-employee.sql): Execute o script conectado na sessão com user "chinook" e service name "XEpdb1". Popula a tabela Employee.

   10. [10-insert-into-customer.sql](https://github.com/LuizWillner/TrabalhoBancoDeDados2/blob/main/scripts/chinook-db-setup/10-insert-into-customer.sql): Execute o script conectado na sessão com user "chinook" e service name "XEpdb1". Popula a tabela Customer.

   11. [11-insert-into-invoice.sql](https://github.com/LuizWillner/TrabalhoBancoDeDados2/blob/main/scripts/chinook-db-setup/11-insert-into-invoice.sql): Execute o script conectado na sessão com user "chinook" e service name "XEpdb1". Popula a tabela Invoice.

   12. [12-insert-into-invoiceline.sql](https://github.com/LuizWillner/TrabalhoBancoDeDados2/blob/main/scripts/chinook-db-setup/12-insert-into-invoiceline.sql): Execute o script conectado na sessão com user "chinook" e service name "XEpdb1". Popula a tabela InvoiceLine.

   13. [13-insert-into-playlist.sql](https://github.com/LuizWillner/TrabalhoBancoDeDados2/blob/main/scripts/chinook-db-setup/13-insert-into-playlist.sql): Execute o script conectado na sessão com user "chinook" e service name "XEpdb1". Popula a tabela Playlist.

   14. [14-insert-into-playlisttrack.sql](https://github.com/LuizWillner/TrabalhoBancoDeDados2/blob/main/scripts/chinook-db-setup/14-insert-into-playlisttrack.sql): Execute o script conectado na sessão com user "chinook" e service name "XEpdb1". Popula a tabela PlaylistTrack.

   15. [15-commit.sql](https://github.com/LuizWillner/TrabalhoBancoDeDados2/blob/main/scripts/chinook-db-setup/15-commit.sql): Execute o script conectado na sessão com user "chinook" e service name "XEpdb1". Faz o commit das alterações (caso autocommit esteja desligado).

## Extras

- Caso deseje dropar todas as tabelas para reiniciar o processo, execute o script [16-drop-tables.sql](https://github.com/LuizWillner/TrabalhoBancoDeDados2/blob/main/scripts/chinook-db-setup/16-drop-tables.sql).
- Caso prefira executar todos os scripts de setup do banco de dados de uma vez, use o script [17-execute-all.sql](https://github.com/LuizWillner/TrabalhoBancoDeDados2/blob/main/scripts/chinook-db-setup/17-execute-all.sql). A modularização do setup do banco foi feita pois, em alguns casos, a execução de tantas operações de uma vez só pode acarretar em erros.
