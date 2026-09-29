SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



create	FUNCTION [dbo].[fConcatena]
(
	@Tipo varchar(10),
	@Filtro	Varchar(50)
)

RETURNS Varchar(500)

AS

BEGIN

	Declare @Tab table(campo varchar(100))

	if upper(@Tipo) = 'DOCS'
		Begin
			insert @Tab
			select ID_DC from Alerta_Email_DocAnexos where ID_Alerta_Email = @Filtro
		End
	Else
		Begin
			insert @Tab
			select Compl_Fone from comunicacao where cd_pes = @Filtro
		End

	Declare @NovoConteudo VarChar(400)
	Declare @Conteudo varchar(400)

	Declare cTemp cursor for 
		select campo from @Tab
	open cTemp
		Fetch Next From cTemp Into @Conteudo
		While @@FETCH_STATUS = 0
			Begin
				if @NovoConteudo='' or @NovoConteudo is Null
					Begin
						Set @NovoConteudo=@Conteudo
					end
				else
					begin
						set @NovoConteudo=@NovoConteudo + ';'  + @Conteudo
					end
				
				Fetch Next From cTemp Into @Conteudo
			end
	close cTemp

	deallocate cTemp 
		
	return @NovoConteudo
	
END



GO
