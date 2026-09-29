SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fBusca_spRPSVIT]--('4262')
(
	@NF	Varchar(10),
	@Codigo varchar(1)
)
RETURNS Varchar(1000)
AS  
BEGIN 

	Declare @NovoConteudo varchar(1000)
	Declare @Conteudo varchar(1000)
	Declare @Obs varchar(300)

	set @OBS = (select ' OBS: ' + replace(replace(obs,CHAR((13)) ,''),char(10),'') from Fatura_ARG with(nolock) where numero = @NF and codigo = @Codigo)

	Declare cTemp cursor for 
		select nome_tp_tx + ' R$: ' + convert(varchar,Valor_ARP) from Fatura_ARG F with(nolock)
		join Fatura_ARG_Det D with(nolock) on D.id_fat = F.id_fat
		join tipo_taxa T with(nolock) on T.cd_tp_tx = D.cd_tp_tx
		where codigo = @Codigo and numero = @NF
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
						set @NovoConteudo=@NovoConteudo + '     ' + @Conteudo
					end
				
				Fetch Next From cTemp Into @Conteudo
			end
	close cTemp

	deallocate cTemp

	return @NovoConteudo + @Obs
	
END










GO
