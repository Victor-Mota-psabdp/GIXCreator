SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
DECLARE @Statement NVARCHAR(300);
set @Statement = 'select 1'
exec sp_executesql @Statement
select Num_Proc + ' '+ cd_tp_tx + ' ' + convert(varchar,valor_arp) from fatura_arg_det where id_fat = 16294
*/


/*
	Essa função concatena todo o conteudo de um select com apenas 1 campo
	ex: 'select campo from tabela'
	ex: 'select Num_Proc + ' ' + cd_tp_tx + ' ' + convert(varchar,valor_arp) from fatura_arg_det where id_fat = 16294'

 */
CREATE FUNCTION [dbo].[fConcatenaCampo]
(
	@Statement NVARCHAR(MAX),
	@Separador varchar(10)
)

RETURNS Varchar(MAX)

AS

BEGIN

	declare @Tab table(campo varchar(500))
--	insert into @Tab 
		exec sp_executesql @Statement

	Declare @NovoConteudo VarChar(MAX)
	Declare @Conteudo varchar(500)

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
						set @NovoConteudo=@NovoConteudo + @Separador  + @Conteudo
					end
				
				Fetch Next From cTemp Into @Conteudo
			end
	close cTemp

	deallocate cTemp 

	return @NovoConteudo
	
END



GO
