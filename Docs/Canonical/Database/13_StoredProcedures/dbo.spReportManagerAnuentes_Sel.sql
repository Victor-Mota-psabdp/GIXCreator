SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[spReportManagerAnuentes_Sel] 'IMCSR20080604602'

CREATE Procedure [dbo].[spReportManagerAnuentes_Sel] 
			@Num_Proc		Varchar(16)

AS

If left(@Num_Proc,1) = 'I' 

	Begin

		Declare @Saida	Varchar(50)


			select  @Saida = COALESCE(@Saida +';','')+ ltrim(rtrim(nome_orgao_anuente)) from solicitacao_li_orgao_anuente SLA with(nolock)
			Join Solicitacao_LI SL with(nolock) on SL.num_solicitacao=SLA.num_solicitacao
			Join Orgao_Anuente OA with(nolock) on OA.ID_orgao=SLA.id_orgao_anuente
			Where num_proc=@Num_Proc group by nome_orgao_anuente
			print @Saida
/*
		Declare	cTemp cursor for
			select distinct nome_orgao_anuente from solicitacao_li_orgao_anuente SLA with(nolock)
			Join Solicitacao_LI SL with(nolock) on SL.num_solicitacao=SLA.num_solicitacao
			Join Orgao_Anuente OA with(nolock) on OA.ID_orgao=SLA.id_orgao_anuente
			Where num_proc='IMCSR20080604601'
		
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

			*/
			if @Saida='' 
				BEgin
					Select Null Saida,protocolo_transmissao from solicitacao_li with(nolock) where num_proc=@num_proc
				End
			Else
				Begin
					select @Saida Saida,protocolo_transmissao from solicitacao_li with(nolock) where num_proc=@num_proc
				End
				
	End
ELSE
	Begin
		select nome_orgao_anuente [Saida], '' protocolo_transmissao from campo_processo CP with(nolock)
		join orgao_anuente OA with(nolock) on OA.id_orgao = CP.campo_dados
		where CP.id_campo = 122 and CP.num_proc = @Num_Proc
	End

--select * from campo_processo where id_campo = 122
GO
