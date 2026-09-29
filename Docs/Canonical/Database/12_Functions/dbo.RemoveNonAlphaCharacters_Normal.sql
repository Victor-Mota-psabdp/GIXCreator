SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--select [dbo].[RemoveNonAlphaCharacters_Normal]('Nº ONU: 2789; Nome apropriado para Embarque: Ácido Acético, ')
--select dbo.[RemoveNonAlphaCharacters_Normal]('TESTE 123456789 %º`YøyãÜ?Ú²?xÚ?y?Üîw~õïÈ AS bolsonaro  presidente 17')
CREATE   Function [dbo].[RemoveNonAlphaCharacters_Normal](@Temp VarChar(MAX))
Returns VarChar(MAX)
AS
Begin

    Declare @KeepValues as varchar(100)
    Declare @ClearValues as varchar(100)
    Set @KeepValues = '%[^A-Za-z 0-9%()?!.;,:/\]%'
    While PatIndex(@KeepValues, @Temp) > 0
        Set @Temp = Stuff(@Temp, PatIndex(@KeepValues, @Temp), 1, '')
	
	set @ClearValues = '%[™£¢¬&*§@$¨?™©¼½¾®´`^~]%'
	While PatIndex(@ClearValues, @Temp) > 0
        Set @Temp = Stuff(@Temp, PatIndex(@ClearValues, @Temp), 1, ' ') 

   --SET @Temp = UPPER(@Temp)
   --     COLLATE sql_latin1_general_cp1250_ci_as

	---- remover acentos
	--DECLARE @outputString VARCHAR(MAX)
	--   -- substituir caracteres acentuados
 --   SET @outputString = @Temp COLLATE SQL_Latin1_General_CP1_CI_AI
 --   SET @outputString = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@outputString, 'á', 'a'), 'à', 'a'), 'â', 'a'), 'ã', 'a'), 'ä', 'a'), 'é', 'e'), 'ê', 'e'), 'ë', 'e'), 'í', 'i'), 'ó', 'o'), 'ô', 'o'), 'ö', 'o')
 --   SET @outputString = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@outputString, 'ú', 'u'), 'ü', 'u'), 'ç', 'c'), 'ñ', 'n'), 'ý', 'y'), 'ß', 'ss'), 'æ', 'ae'), 'œ', 'oe'), 'ø', 'o'), 'å', 'a')
	--SET @outputString = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@outputString, 'Á', 'A'), 'À', 'A'), 'Â', 'A'), 'Ã', 'A'), 'Ä', 'A'), 'É', 'E'), 'Ê', 'E'), 'Ë', 'E'), 'Í', 'I'), 'Ó', 'O'), 'Ô', 'O'), 'Ö', 'O')
 --   SET @outputString = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@outputString, 'Ú', 'U'), 'Ü', 'U'), 'Ç', 'C'), 'Ñ', 'N'), 'Ý', 'Y'), 'Þ', 'TH'), 'Æ', 'AE'), 'Œ', 'OE'), 'Ø', 'O'), 'Å', 'A')

 --   RETURN @outputString COLLATE SQL_Latin1_General_CP1_CS_AS

    -- remover outros caracteres especiais
   -- SET @Temp = REPLACE(@outputString, '&', 'and')

    Return @Temp
End

GO
