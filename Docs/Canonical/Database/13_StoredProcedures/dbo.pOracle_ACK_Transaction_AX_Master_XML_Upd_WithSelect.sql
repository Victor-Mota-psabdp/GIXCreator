SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from AX_Master_XML with(nolock) where dt_envio> getdate() -5 order by dt_envio
--select * from ATL_INT.[dbo].[Oracle_ACK_Transaction] where originalmessageid = '{43b94020-f38c-465a-b01a-d0c094411c10}'
--select dbo.ExtrairGuidDoNomeArquivo(replace('BR1ATL_Oracle_Cancel_1_4452_AR_9ec58f19-0254-4144-99a8-0f9e410b9f68_20260616.xml','Cancel_',''))
Create Procedure [dbo].[pOracle_ACK_Transaction_AX_Master_XML_Upd_WithSelect]

AS
--WrongWHTTAXValue
BEGIN			
	UPDATE 
		t1
	SET 		
		Verificado = 1
		--ErrorMessage = t2.TXT
		--MessageId = case when t2.ApprovalResult = 'SUCCESS' then t2.OriginalMessageId else null end
		FROM 
		Atlantis.dbo.AX_Master_XML t1
	JOIN (
		SELECT A.MessageId OriginalMessageId,A.Verificado,TRA.ApprovalResult,TRA.TXT
		FROM Atlantis.dbo.AX_Master_XML A with(nolock)
		join ATL_INT.[dbo].[Oracle_ACK_Transaction] TRA with(nolock) on Replace(Replace(A.MessageId ,'{',''),'}','') 	 = Replace(Replace(TRA.originalmessageid,'{',''),'}','') 			
		Where			
			isnull(A.Verificado,0) = 0
			and TRA.ApprovalResult = 'SUCCESS' 
	) t2
	ON Replace(Replace(t2.OriginalMessageId,'{',''),'}','') = Replace(Replace(T1.MessageId ,'{',''),'}','')
	

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
