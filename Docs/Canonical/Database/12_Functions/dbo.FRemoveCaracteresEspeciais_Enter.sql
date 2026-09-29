SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[FRemoveCaracteresEspeciais_Enter] 
(
	@txt varchar(max)
) RETURNS varchar(max) 
AS
BEGIN
 IF @txt IS NULL BEGIN 
     RETURN NULL
 END
 DECLARE @txt0 varchar(max) 
	SET @txt0 = replace(@txt COLLATE Latin1_General_BIN,char(13)+ char(10),'')
	SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(13),'')
	SET @txt0 = replace(@txt0 COLLATE Latin1_General_BIN,char(10),'')
 RETURN (@txt0)
END

GO
