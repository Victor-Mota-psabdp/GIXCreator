SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[spATL_ExtratoConciliacao_NEW_Rel]

(
	@Dt_Inicial datetime,	
	@Dt_Final datetime
)
AS

declare @soma float
set @soma = 0
declare @Tab table 
(
	[Fecha]			varchar(10),
	[Concepto]		varchar(100),
	[Debito]		float,
	[Credito]		float,
	[Saldo]			float,		
	[LA/DA]			varchar(100),
	[Provedor]		varchar(100),
	[Centro_custo]	varchar(100), 
	[MA/MB]			varchar(100)	
)

	Begin
		insert @tab

		select 
			MCC.Dt_Pgto_Rcto_Mov							[Fecha],
			MCC.Historico									[Concepto],
			(case when dc_mov = 'D' then vlr_doc_mov end)	[Debito],
			(case when dc_mov = 'C' then vlr_doc_mov end)	[Credito],
			''												[Saldo],		
			Num_lcto_rec									[LA/DA],
			isnull(P.Apelido,PP.Apelido)					[Provedor],
			cu.nome_Centro_custo							[Centro_custo], 
			MCC.num_lcto_mov								[MA/MB]		
		from mvto_cta_cte MCC With(nolock)
			join rec_cta_cte RCC With(nolock) on RCC.num_lcto_mov = MCC.num_lcto_mov
			left join Pgto_rcto  PR With(nolock) on PR.num_lcto = RCC.num_lcto_rec
			left join Pgto_rcto_div PRD With(nolock) on PRD.num_lcto_div = RCC.num_lcto_rec
			left join centro_custo CU With(nolock) on cu.cd_centro_custo = pr.cd_centro_custo
			left join Pessoa P With(nolock) on P.cd_pes = Pr.cd_pes
			left join Pessoa PP With(nolock) on PP.cd_pes = PRD.cd_pes
		Where 
			convert(datetime,Dt_Pgto_Rcto_Mov,105) between @Dt_inicial and @Dt_final

	end

	Begin
		update @tab
		set @soma = (case when [Debito] > 0 then @soma - [Debito]
						else @soma + [Credito] end),
		
		[Saldo] = @soma
		
	end

select * from @Tab order by [MA/MB]
GO
