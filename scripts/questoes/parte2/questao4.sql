-- 4. A base original do Chinook possui uma coluna Total na tabela Invoice representada 
-- de forma redundante com as informações contidas nas colunas UnitPrice e 
-- Quantity na tabela InvoiceLine. Podemos identificar nesse caso uma regra 
-- semântica onde o valor Total de um Invoice deve ser igual à soma de UnitPrice * 
-- Quantity de todos os registros de InvoiceLine relacionados a um Invoice. 
-- Implementar uma solução que garanta a integridade dessa regra.
CREATE OR REPLACE PROCEDURE atualizar_total_invoice(p_invoiceid NUMBER) AS
    v_total NUMBER;
BEGIN
    -- Calcula o total da invoice com base nas linhas de invoice
    SELECT SUM(quantity * unitprice)
    INTO v_total
    FROM invoiceline
    WHERE invoiceid = p_invoiceid;
    
    -- Atualiza o total na tabela invoice
    UPDATE invoice
    SET total = v_total
    WHERE invoiceid = p_invoiceid;

END atualizar_total_invoice;


CREATE OR REPLACE TRIGGER trigger_atualizar_total_invoice
AFTER INSERT OR UPDATE OF quantity, unitprice ON invoiceline
BEGIN
    -- Chama a procedure para atualizar o total da invoice
    -- A procedure atualizará o total com base no invoiceid
    FOR r IN (SELECT DISTINCT invoiceid FROM invoiceline WHERE invoiceid IS NOT NULL) LOOP
        atualizar_total_invoice(r.invoiceid);
    END LOOP;
END trigger_atualizar_total_invoice;


update invoiceline
set unitprice = 0.99
where invoicelineid = 1;