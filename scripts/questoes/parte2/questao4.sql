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

-- TESTE DE MUDANÇA DE INVOICELINE
update invoiceline
set unitprice = 0.99
where invoicelineid = 1;


-- TRIGGER PARA IMPEDIR O UPDATE E INNSERT DO VALOR TOTAL
CREATE OR REPLACE TRIGGER trg_invoice_total
BEFORE INSERT OR UPDATE ON invoice
FOR EACH ROW
BEGIN
    -- Bloqueia atualização manual do TOTAL
    IF UPDATING THEN
        RAISE_APPLICATION_ERROR(-20010, 'O valor de TOTAL não pode ser alterado manualmente');
    END IF;
    -- Bloqueia inserção manual do TOTAL
    IF INSERTING THEN
        IF :NEW.TOTAL IS NOT NULL THEN
            RAISE_APPLICATION_ERROR(-20010, 'O valor de TOTAL não pode ser inserido manualmente');
        END IF;
        IF :NEW.TOTAL IS NULL THEN
            :NEW.TOTAL := 0;
        END IF;
    END IF;
END;


-- TESTE DE UPDATE
UPDATE INVOICE
SET TOTAL = 10
WHERE INVOICEID = 1;


-- Teste Insert
INSERT INTO invoice (
    invoiceid,
    CustomerId,
    InvoiceDate,
    BillingAddress,
    BillingCity,
    BillingState,
    BillingCountry,
    BillingPostalCode
)
VALUES (
    10000,                   -- GARANTIR QUE NÃO É UM ID EXISTENTE
    1,                       -- CustomerId (substitua por um ID de cliente válido)
    SYSDATE,                 -- InvoiceDate (data atual)
    'Rua Exemplo',           -- BillingAddress
    'São Paulo',             -- BillingCity
    'SP',                    -- BillingState
    'Brasil',                -- BillingCountry
    '12345-678'              -- BillingPostalCode
);

DELETE FROM INVOICE WHERE INVOICEID = 10000;
