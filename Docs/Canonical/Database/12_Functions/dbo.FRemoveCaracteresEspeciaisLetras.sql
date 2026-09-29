SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select dbo.[FRemoveLetras] ('BDP CC 200366')
--select [dbo].[FRemoveCaracteresEspeciais]  ('BDP CC 200366')
--select [dbo].[FRemoveAcentuacao] ('BDP CC 200366')
--select [dbo].[RemoveNonAlphaCharacters] ('BDP CC 200366')
--select [dbo].[FRemoveCaracteresEspeciais_EFreight] ('BDP CC 200366')
--select [dbo].[FRemoveCaracteresEspeciais_Enter] ('BDP CC 200366')
--select [dbo].[FRemoveCaracteresEspeciais_Schneider] ('BDP CC 200366')
--select [dbo].[FRemoveCaracteresEspeciaisClaudio] ('BDP CC 200366')
--select [dbo].[FRemoveSpecial_chars]('BDP CC 200366')


Create FUNCTION [dbo].[FRemoveCaracteresEspeciaisLetras] 
(
	@TEXTO varchar(max)
) 

RETURNS varchar(max) 
AS
BEGIN

	DECLARE @RESULTADO VARCHAR(max)

	SET @RESULTADO = ''

	;WITH SPLIT AS
	(
	SELECT 1 AS ID, SUBSTRING(@TEXTO, 1, 1) AS LETRA
	UNION ALL
	SELECT ID + 1, SUBSTRING(@TEXTO, ID + 1, 1)
	FROM SPLIT
	WHERE ID < LEN(@TEXTO)
	)

	SELECT @RESULTADO += (CASE WHEN LETRA COLLATE sql_latin1_general_cp1251_ci_as LIKE '[0-9]' THEN LETRA ELSE '' END)
	FROM SPLIT
	OPTION(MAXRECURSION 0)

	RETURN @RESULTADO

 
END


GO
