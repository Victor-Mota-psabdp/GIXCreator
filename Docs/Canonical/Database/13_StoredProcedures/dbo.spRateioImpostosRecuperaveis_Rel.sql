SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--spRateioImpostosRecuperaveis_Rel 'IMSUN201108068BR'

CREATE procedure [dbo].[spRateioImpostosRecuperaveis_Rel] 
	@JOB varchar(16)
as

declare @Tab table (
	[Prod] varchar(100), 
	[IR s/ Honorários BDP Valor] float,
	[CSLL s/ Honorários BDP Valor] float,
	[PIS s/ Honorários BDP Valor] float,
	[COFINS s/ Honorários BDP Valor] float,
	[ICMS s/ Transp. Valor] float
)

	Begin 
		Insert @Tab -- os resultados são multiplicados por -1 pq devem aparecer negativos no relatório
			select PROD.cd_proc_cliente, 
				dbo.fBusca_Custo(@JOB,PS.CD_Pedido, PS.Cd_Produto,'IRRF%') * -1 [IR s/ Honorários BDP Valor],
				dbo.fBusca_Custo(@JOB,PS.CD_Pedido, PS.Cd_Produto,'CSLL (01) (1,00%)') * -1 [CSLL s/ Honorários BDP Valor],
				dbo.fBusca_Custo(@JOB,PS.CD_Pedido, PS.Cd_Produto,'PIS(01) (0,65%) ') * -1 [PIS s/ Honorários BDP Valor],
				dbo.fBusca_Custo(@JOB,PS.CD_Pedido, PS.Cd_Produto,'Cofins (01) (3,00%)') * -1 [COFINS s/ Honorários BDP Valor],
				dbo.fBusca_Custo(@JOB,PS.CD_Pedido, PS.Cd_Produto,'ICMS s/ Transp.') *-1 [ICMS s/ Transp.]
			from
				Pedido_Ship PS with(nolock) 
				left join produto_cliente PROD with(nolock) on PROD.cd_prod = PS.cd_produto
			where
				PS.num_proc=@JOB
	End

	SELECT 	
		[Prod], 
		[IR s/ Honorários BDP Valor] IRRF,
		[CSLL s/ Honorários BDP Valor] CSLL,
		[PIS s/ Honorários BDP Valor] PIS,
		[COFINS s/ Honorários BDP Valor] COFINS,
		[ICMS s/ Transp. Valor] ICMS_Transp
	FROM 
		@TAB


GO
