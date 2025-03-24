CREATE TABLE Produto (
    Codigo INT PRIMARY KEY,
    Nome VARCHAR(100),
    Valor DECIMAL(10, 2)  -- Preço unitário do produto
);

CREATE TABLE ENTRADA (
    Codigo_Transacao INT PRIMARY KEY,
    Codigo_Produto INT,
    Quantidade INT,
    Valor_Total DECIMAL(10, 2),
    FOREIGN KEY (Codigo_Produto) REFERENCES Produto(Codigo)
);

CREATE TABLE SAIDA (
    Codigo_Transacao INT PRIMARY KEY,
    Codigo_Produto INT,
    Quantidade INT,
    Valor_Total DECIMAL(10, 2),
    FOREIGN KEY (Codigo_Produto) REFERENCES Produto(Codigo)
);
GO

CREATE PROCEDURE RegistrarTransacao
    @Tipo CHAR(1),  -- 'e' para ENTRADA, 's' para SAÍDA
    @Codigo_Transacao INT,
    @Codigo_Produto INT,
    @Quantidade INT
AS
BEGIN
    -- Declaração de variável para armazenar o valor unitário do produto
    DECLARE @Valor_Unitario DECIMAL(10, 2);
    DECLARE @Valor_Total DECIMAL(10, 2);
    
    -- Obter o valor unitário do produto
    SELECT @Valor_Unitario = Valor
    FROM Produto
    WHERE Codigo = @Codigo_Produto;
    
    -- Se não encontrar o produto, lançar erro
    IF @Valor_Unitario IS NULL
    BEGIN
        RAISERROR('Produto não encontrado!', 16, 1);
        RETURN;
    END
    
    -- Calcular o valor total da transação
    SET @Valor_Total = @Valor_Unitario * @Quantidade;
    
    -- Verificar o tipo de transação e inserir na tabela correspondente
    IF @Tipo = 'e'  -- Entrada
    BEGIN
        -- Inserir na tabela ENTRADA
        INSERT INTO ENTRADA (Codigo_Transacao, Codigo_Produto, Quantidade, Valor_Total)
        VALUES (@Codigo_Transacao, @Codigo_Produto, @Quantidade, @Valor_Total);
    END
    ELSE IF @Tipo = 's'  -- Saída
    BEGIN
        -- Inserir na tabela SAÍDA
        INSERT INTO SAIDA (Codigo_Transacao, Codigo_Produto, Quantidade, Valor_Total)
        VALUES (@Codigo_Transacao, @Codigo_Produto, @Quantidade, @Valor_Total);
    END
    ELSE
    BEGIN
        -- Caso o tipo não seja 'e' nem 's', lançar erro
        RAISERROR('Código de transação inválido! Use ''e'' para ENTRADA ou ''s'' para SAÍDA.', 16, 1);
    END
END;

EXEC RegistrarTransacao 'e', 1001, 1, 50;  -- Exemplo de entrada (produto com código 1, quantidade 50)

EXEC RegistrarTransacao 's', 1002, 1, 20;  -- Exemplo de saída (produto com código 1, quantidade 20)

SELECT * FROM SAIDA;

SELECT * FROM ENTRADA;

INSERT INTO Produto (Codigo,Nome, Valor) VALUES(1, 'produto10',10.0),
											   (2, 'produto20',20.0)

SELECT * FROM Produto;
