SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[PreencheStringV2] (
@Valor varchar(500), 
@QTD int,
@string varchar(500)
) returns varchar(500)
as
Begin

	set @Valor = Isnull(@Valor,'')

	if LEN(@Valor) > @QTD
		Begin
			set @string= @Valor
		End
	else
		begin
			set @string = ( replicate(@string,(@QTD - len(cast(@Valor as varchar(500))))) + cast(@Valor as Varchar(500)))
		end
		return @string
end




GO
