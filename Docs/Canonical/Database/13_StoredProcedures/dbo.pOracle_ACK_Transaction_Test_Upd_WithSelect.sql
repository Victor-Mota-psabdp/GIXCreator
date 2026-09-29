SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[pOracle_ACK_Transaction_Test_Upd_WithSelect]

AS

BEGIN			
	UPDATE 
		t1
	SET 		
		Verificado = 1,
		ErrorMessage = t2.TXT
		,MessageId = case when t2.ApprovalResult = 'SUCCESS' then t2.OriginalMessageId else null end
		FROM 
		Atlantis.dbo.AX_DOC_XML_Oracle_Test t1
	JOIN (
		SELECT dbo.ExtrairGuidDoNomeArquivo(replace(A.Nome_Arquivo,'QA_','')) OriginalMessageId,A.Verificado,TRA.ApprovalResult,TRA.TXT,A.MessageID
		FROM Atlantis.dbo.AX_DOC_XML_Oracle_Test A with(nolock)
		join ATL_INT.[dbo].[Oracle_ACK_Transaction] TRA with(nolock) on Replace(Replace(dbo.ExtrairGuidDoNomeArquivo(replace(Nome_arquivo,'QA_','')),'{',''),'}','') = Replace(Replace(TRA.originalmessageid,'{',''),'}','') 			
		Where			
			isnull(A.Verificado,0) = 0
			--and A.MessageID is null

			----originalmessageid  = '9eddddb4-802f-4036-bde2-067b8f431fc8' and
			--isnull(A.Verificado,0) = 1
			--and A.ErrorMessage is not null
			--and TRA.ApprovalResult = 'SUCCESS'
	) t2
	ON Replace(Replace(t2.OriginalMessageId,'{',''),'}','') = Replace(Replace(dbo.ExtrairGuidDoNomeArquivo(replace(T1.Nome_arquivo,'QA_','')),'{',''),'}','') 
	

END



---- Criar função para extrair GUID
--CREATE FUNCTION dbo.ExtrairGuidDoNomeArquivo(@NomeArquivo VARCHAR(255))
--RETURNS VARCHAR(36)
--AS
--BEGIN
--    RETURN PARSENAME(REPLACE(@NomeArquivo, '_', '.'), 2);
--END;
--GO

--ALTER FUNCTION dbo.ExtrairGuidDoNomeArquivo(@NomeArquivo VARCHAR(255))
--RETURNS VARCHAR(36)
--AS
--BEGIN
--    DECLARE @Pos1 INT, @Pos2 INT, @Pos3 INT, @Pos4 INT, @Pos5 INT, @Pos6 INT;
--    DECLARE @Guid VARCHAR(36);

--     Encontrar as 6 ocorrências de "_"
--    SET @Pos1 = CHARINDEX('_', @NomeArquivo);
--    SET @Pos2 = CHARINDEX('_', @NomeArquivo, @Pos1 + 1);
--    SET @Pos3 = CHARINDEX('_', @NomeArquivo, @Pos2 + 1);
--    SET @Pos4 = CHARINDEX('_', @NomeArquivo, @Pos3 + 1);
--    SET @Pos5 = CHARINDEX('_', @NomeArquivo, @Pos4 + 1);
--    SET @Pos6 = CHARINDEX('_', @NomeArquivo, @Pos5 + 1);

--     Extrair o GUID entre a 5ª e 6ª ocorrência de "_"
--    IF @Pos5 > 0 AND @Pos6 > 0
--    BEGIN
--        SET @Guid = SUBSTRING(@NomeArquivo, @Pos5 + 1, @Pos6 - @Pos5 - 1);
--    END
--    ELSE
--    BEGIN
--        SET @Guid = NULL; -- Não encontrou o padrão esperado
--    END

--    RETURN @Guid;
--END;
--GO

-- Usar a função no UPDATE


/*

SELECT 
    Nome_arquivo,
    '''' +s.value+ ''',' AS GuidExtratido
from AX_DOC_XML_Oracle O with(nolock)
join AX_DOC_Oracle AX with(nolock) on AX.ID_AX = O.ID_AX
CROSS APPLY (
    SELECT value
    FROM (
        SELECT 
            value,
            ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS Posicao
        FROM STRING_SPLIT(O.Nome_arquivo, '_')
    ) x
    WHERE Posicao = 6
) s;
*/



GO
