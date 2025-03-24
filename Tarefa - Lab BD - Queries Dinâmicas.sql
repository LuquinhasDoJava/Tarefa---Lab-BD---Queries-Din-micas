CREATE TABLE Produto (
    Codigo INT PRIMARY KEY,
    Nome VARCHAR(100),
    Valor DECIMAL(10, 2)  -- Pre�o unit�rio do produto
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
    @Tipo CHAR(1),  -- 'e' para ENTRADA, 's' para SA�DA
    @Codigo_Transacao INT,
    @Codigo_Produto INT,
    @Quantidade INT
AS
BEGIN
    -- Declara��o de vari�vel para armazenar o valor unit�rio do produto
    DECLARE @Valor_Unitario DECIMAL(10, 2);
    DECLARE @Valor_Total DECIMAL(10, 2);
    
    -- Obter o valor unit�rio do produto
    SELECT @Valor_Unitario = Valor
    FROM Produto
    WHERE Codigo = @Codigo_Produto;
    
    -- Se n�o encontrar o produto, lan�ar erro
    IF @Valor_Unitario IS NULL
    BEGIN
        RAISERROR('Produto n�o encontrado!', 16, 1);
        RETURN;
    END
    
    -- Calcular o valor total da transa��o
    SET @Valor_Total = @Valor_Unitario * @Quantidade;
    
    -- Verificar o tipo de transa��o e inserir na tabela correspondente
    IF @Tipo = 'e'  -- Entrada
    BEGIN
        -- Inserir na tabela ENTRADA
        INSERT INTO ENTRADA (Codigo_Transacao, Codigo_Produto, Quantidade, Valor_Total)
        VALUES (@Codigo_Transacao, @Codigo_Produto, @Quantidade, @Valor_Total);
    END
    ELSE IF @Tipo = 's'  -- Sa�da
    BEGIN
        -- Inserir na tabela SA�DA
        INSERT INTO SAIDA (Codigo_Transacao, Codigo_Produto, Quantidade, Valor_Total)
        VALUES (@Codigo_Transacao, @Codigo_Produto, @Quantidade, @Valor_Total);
    END
    ELSE
    BEGIN
        -- Caso o tipo n�o seja 'e' nem 's', lan�ar erro
        RAISERROR('C�digo de transa��o inv�lido! Use ''e'' para ENTRADA ou ''s'' para SA�DA.', 16, 1);
    END
END;

EXEC RegistrarTransacao 'e', 1001, 1, 50;  -- Exemplo de entrada (produto com c�digo 1, quantidade 50)

EXEC RegistrarTransacao 's', 1002, 1, 20;  -- Exemplo de sa�da (produto com c�digo 1, quantidade 20)

SELECT * FROM SAIDA;

SELECT * FROM ENTRADA;

INSERT INTO Produto (Codigo,Nome, Valor) VALUES(1, 'produto10',10.0),
											   (2, 'produto20',20.0)

SELECT * FROM Produto;
