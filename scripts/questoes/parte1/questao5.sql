-- 5. Implemente uma solução através da programação em banco de dados para validar os 
-- valores de uma coluna que represente uma situação (estado) garantindo que os seus 
-- valores e suas transições atendam a especificação de um diagrama de transição de 
-- estados (DTE). Quanto mais genérica e reutilizável for a solução melhor a pontuação 
-- nessa questão. Junto da solução deverá ser entregue um cenário de teste 
-- demonstrando o funcionamento da solução.

-- Cria e popula a tabela que armazena a ordem de transição de estados
CREATE TABLE StateTransitions (
    CurrentState VARCHAR2(50) NOT NULL,
    NextState VARCHAR2(50) NOT NULL,
    PRIMARY KEY (CurrentState, NextState)
);

INSERT INTO StateTransitions (CurrentState, NextState) VALUES ('Open', 'Canceled');
INSERT INTO StateTransitions (CurrentState, NextState) VALUES ('Open', 'Closed');
INSERT INTO StateTransitions (CurrentState, NextState) VALUES ('Closed', 'Canceled');
INSERT INTO StateTransitions (CurrentState, NextState) VALUES ('Closed', 'Paid');

SELECT *
FROM STATETRANSITIONS s 

-- Cria uma nova coluna na tabela 'Invoice' para armazenar o status da fatura
ALTER TABLE Invoice ADD Status VARCHAR2(50) DEFAULT 'Open';

-- Procedure para alterar o status
CREATE OR REPLACE PROCEDURE UpdateInvoiceStatus(
    invoice_id IN NUMBER,      
   	status_novo IN VARCHAR2    
) AS
   	status_atual VARCHAR2(50);  
    transicao_valida INTEGER; 
BEGIN
    -- Obter o status atual da fatura
    SELECT status
    INTO status_atual
    FROM Invoice
    WHERE InvoiceId = invoice_id;

    -- Verificar se a transição é válida
    SELECT COUNT(*)
    INTO transicao_valida
    FROM StateTransitions
    WHERE CurrentState = status_atual
      AND NextState = status_novo;

    -- Se a transição não for válida, gerar um erro
    IF transicao_valida = 0 THEN
        RAISE_APPLICATION_ERROR(
            -20001,
            'Transição de estado inválida: ' || status_atual || ' -> ' || status_novo
        );
    END IF;

    -- Atualizar o status da fatura
    UPDATE Invoice
    SET Status = status_novo
    WHERE InvoiceId = invoice_id;

    COMMIT;
END;

-- Teste 1: Transição válida (Open -> Canceled)
BEGIN
    UpdateInvoiceStatus(1, 'Closed');
END;

-- Teste 2: Transição válida (Pending -> Cancelled)
BEGIN
    UpdateInvoiceStatus(2, 'Canceled');
END;

-- Teste 3: Transição inválida (Open -> Paid)
BEGIN
    UpdateInvoiceStatus(3, 'Paid');
END;

-- Teste 4: Transição inválida (Closed -> Open)
BEGIN
    UpdateInvoiceStatus(1, 'Open');
END;

