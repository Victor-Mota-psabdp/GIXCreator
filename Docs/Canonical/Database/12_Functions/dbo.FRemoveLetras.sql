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


CREATE FUNCTION [dbo].[FRemoveLetras] 
(
	@number varchar(max)
) 

RETURNS varchar(max) 
AS
BEGIN
 DECLARE @c int
 SET @c=65
 WHILE @c<(65+62) BEGIN
  SET @number=replace(@number,char(@c),'')
  SET @c=@c+1
 END
 RETURN(@number)
END


GO
