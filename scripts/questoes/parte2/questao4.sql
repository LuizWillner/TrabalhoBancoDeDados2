-- 4. A base original do Chinook possui uma coluna Total na tabela Invoice representada 
-- de forma redundante com as informações contidas nas colunas UnitPrice e 
-- Quantity na tabela InvoiceLine. Podemos identificar nesse caso uma regra 
-- semântica onde o valor Total de um Invoice deve ser igual à soma de UnitPrice * 
-- Quantity de todos os registros de InvoiceLine relacionados a um Invoice. 
-- Implementar uma solução que garanta a integridade dessa regra.


-- Procedure para inserir ou atualizar invoiceline. Atualiza coluna total em invoice de acordo com a regra semântica
CREATE OR REPLACE PROCEDURE manage_invoiceline(
    p_invoicelineid IN invoiceline.INVOICELINEID%TYPE,
    p_invoiceid IN invoiceline.INVOICEID%TYPE,
    p_trackid IN invoiceline.TRACKID%TYPE,
    p_unitprice IN invoiceline.UNITPRICE%TYPE,
    p_quantity IN invoiceline.QUANTITY%TYPE
) IS
	v_total invoice.TOTAL%TYPE;
BEGIN
    -- Comando MERGE utilizado para inserir ou atualizar invoiceline
    MERGE INTO invoiceline il
    USING (SELECT p_invoicelineid AS invoicelineid FROM dual) src
    ON (il.invoicelineid = src.invoicelineid)
    WHEN MATCHED THEN
        UPDATE SET
            il.invoiceid = p_invoiceid,
            il.trackid = p_trackid,
            il.unitprice = p_unitprice,
            il.quantity = p_quantity
    WHEN NOT MATCHED THEN
        INSERT 
        	(invoicelineid, invoiceid, trackid, unitprice, quantity)
        VALUES 
       		(p_invoicelineid, p_invoiceid, p_trackid, p_unitprice, p_quantity);
       	
    -- Atualiza o total em invoice
    SELECT SUM(il.unitprice * il.quantity)
    INTO v_total
    FROM INVOICE i
    JOIN INVOICELINE il ON i.invoiceid = il.invoiceid  
    WHERE i.invoiceid = p_invoiceid
	GROUP BY i.invoiceid;

	UPDATE invoice
    SET total = v_total
    WHERE invoiceid = p_invoiceid;
END;

DROP PROCEDURE ATUALIZAR_TOTAL_INVOICE;

DROP TRIGGER TRIGGER_ATUALIZAR_TOTAL_INVOICE;


BEGIN
	manage_invoiceline(10000, 1, 130, 30.0, 1);
END;


-- Conceder permissão para executar a procedure manage_invoiceline
GRANT EXECUTE ON manage_invoiceline TO usuario_limitado;
