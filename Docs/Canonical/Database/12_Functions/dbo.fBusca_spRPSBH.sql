SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select ascII(LEFT(Right(obs,2),1)) from Fatura_ARG where numero = '4261'
--select ascII(Right(obs,1)) from Fatura_ARG where numero = '4261'
--select replace(obs,CHAR((10)) ,'') from Fatura_ARG where numero = '4261'
--
-- IAATL20205064BR PI 024/2
--
--select [dbo].[fBusca_spRPSBH]('4262')
-- IAATL201205064BR PI 024/12  
-- IAATL201205064BR PI 024/12
--Desconsolidação 86     Collect Fee 64.5     DELIVERY FEE 107.5 OBS:  IAATL201205064BR PI 024/12

CREATE FUNCTION [dbo].[fBusca_spRPSBH]--('4262')
(
	@NF	Varchar(10)
)
RETURNS Varchar(1000)
AS  
BEGIN 

	Declare @NovoConteudo varchar(1000)
	Declare @Conteudo varchar(1000)
	Declare @Obs varchar(100)

	set @OBS = (select ' OBS: ' + replace(replace(obs,CHAR((13)) ,''),char(10),'') from Fatura_ARG where numero = @NF)

	Declare cTemp cursor for 
		select nome_tp_tx + ' ' + convert(varchar,Valor_ARP) from Fatura_ARG F
		join Fatura_ARG_Det D on D.id_fat = F.id_fat
		join tipo_taxa T on T.cd_tp_tx = D.cd_tp_tx
		where codigo = 'D' and numero = @NF
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
