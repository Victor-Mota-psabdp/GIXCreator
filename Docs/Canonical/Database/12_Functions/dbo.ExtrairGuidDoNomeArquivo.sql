SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.ExtrairGuidDoNomeArquivo(@NomeArquivo VARCHAR(255))
RETURNS VARCHAR(36)
AS
BEGIN
    DECLARE @Pos1 INT, @Pos2 INT, @Pos3 INT, @Pos4 INT, @Pos5 INT, @Pos6 INT;
    DECLARE @Guid VARCHAR(36);

    -- Encontrar as 6 ocorrências de "_"
    SET @Pos1 = CHARINDEX('_', @NomeArquivo);
    SET @Pos2 = CHARINDEX('_', @NomeArquivo, @Pos1 + 1);
    SET @Pos3 = CHARINDEX('_', @NomeArquivo, @Pos2 + 1);
    SET @Pos4 = CHARINDEX('_', @NomeArquivo, @Pos3 + 1);
    SET @Pos5 = CHARINDEX('_', @NomeArquivo, @Pos4 + 1);
    SET @Pos6 = CHARINDEX('_', @NomeArquivo, @Pos5 + 1);

    -- Extrair o GUID entre a 5ª e 6ª ocorrência de "_"
    IF @Pos5 > 0 AND @Pos6 > 0
    BEGIN
        SET @Guid = SUBSTRING(@NomeArquivo, @Pos5 + 1, @Pos6 - @Pos5 - 1);
    END
    ELSE
    BEGIN
        SET @Guid = NULL; -- Não encontrou o padrão esperado
    END

    RETURN @Guid;
END;

GO
