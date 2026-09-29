SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select dbo.RemoveNonAlphaCharacters_TST('TESTE 123456789 %º`YøyãÜ?Ú²?xÚ?y?Üîw~õïÈ AS bolsonaro  presidente 17')
CREATE Function [dbo].[RemoveNonAlphaCharacters](@Temp VarChar(8000))
Returns VarChar(MAX)
AS
Begin

    Declare @KeepValues as varchar(100)
    Declare @ClearValues as varchar(100)
    Set @KeepValues = '%[^A-Za-z 0-9´`^~%()?!.;,:/\]%'
    While PatIndex(@KeepValues, @Temp) > 0
        Set @Temp = Stuff(@Temp, PatIndex(@KeepValues, @Temp), 1, '')
	
	set @ClearValues = '%[™£¢¬&*§@$¨?™©¼½¾®]%'
	While PatIndex(@ClearValues, @Temp) > 0
        Set @Temp = Stuff(@Temp, PatIndex(@ClearValues, @Temp), 1, ' ')
   --set @Temp = replace(@temp,'ª','')
   SET @Temp = UPPER(@Temp)
        COLLATE sql_latin1_general_cp1250_ci_as
    Return @Temp
End
GO
