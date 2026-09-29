SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[PreencheStringDireita] (
@Valor varchar(500), 
@QTD int,
@string varchar(500)
) returns varchar(500)
as

begin
set @Valor = Isnull(@Valor,'')
return (cast(@Valor as Varchar(500)) + replicate(@string,(@QTD - len(cast(@Valor as varchar(500))))))
end
GO
