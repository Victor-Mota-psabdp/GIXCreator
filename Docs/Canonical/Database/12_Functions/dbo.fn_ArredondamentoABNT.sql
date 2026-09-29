SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_ArredondamentoABNT
(
    @Valor DECIMAL(18,6) -- Aceita até 6 casas decimais para o cálculo
)
RETURNS DECIMAL(10,2)    -- Retorna o valor formatado com 2 casas decimais
AS
BEGIN
    DECLARE @Resultado DECIMAL(10,2);
    DECLARE @Arredondado DECIMAL(10,2);

    -- 1. Arredondamento padrão do SQL Server
    SET @Arredondado = ROUND(@Valor, 2);

    -- 2. Verifica se o 3º decimal é EXATAMENTE 5 (a diferença exata é 0.005)
    IF (@Arredondado - @Valor = 0.005)
    BEGIN
        -- 3. Verifica se o 2º decimal (que vai permanecer) é PAR ou ÍMPAR
        -- Multiplicamos por 100, removemos a parte decimal com FLOOR e tiramos o módulo 2
        IF (FLOOR(@Valor * 100) % 2 = 0) 
        BEGIN
            -- Se for PAR: O SQL subiu, mas a ABNT manda manter. Subtraímos 0.01.
            SET @Resultado = @Arredondado - 0.01;
        END
        ELSE 
        BEGIN
            -- Se for ÍMPAR: O SQL subiu e a ABNT concorda. Mantém o valor.
            SET @Resultado = @Arredondado;
        END
    END
    ELSE
    BEGIN
        -- 4. Se não for exatamente 5 (for menor ou maior), usa o arredondamento normal
        SET @Resultado = @Arredondado;
    END

    RETURN @Resultado;
END

GO
