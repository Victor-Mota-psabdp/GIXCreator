SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE function [dbo].[F_BuscaOrgaoAnuente_Sel] --'IMCSR20080604601'
			(
			@Num_Solicitacao		Varchar(12)
			)

returns
	VarchaR(400)
AS
Begin
	Declare @Saida	Varchar(50)
	Declare @orgao	Varchar(40)
	
	Set @Saida=''
	Set @Orgao=''


	Declare	cTemp cursor for
		select distinct nome_orgao_anuente from solicitacao_li_orgao_anuente SLA
		Join Solicitacao_LI SL on SL.num_solicitacao=SLA.num_solicitacao
		Join Orgao_Anuente OA on OA.ID_orgao=SLA.id_orgao_anuente
		Where SL.num_solicitacao=@Num_Solicitacao
	
		open cTemp
			Fetch Next From cTemp Into @orgao
			While @@FETCH_STATUS = 0
				Begin
					if @orgao<>'' and @orgao is not null
						if @Saida='' 
							Begin
								Set @Saida=@Orgao
							End
						Else
							Begin
								Set @Saida=@Saida + ' ; ' + @orgao
							End
						Fetch Next From cTemp Into @orgao
				End
		close cTemp
		deallocate cTemp

		return @SAida		




End
GO
