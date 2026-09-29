SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE Procedure [dbo].[spContas_Pagar_Rel] -- '2011-06-03','2011-06-03','%'

	(
	@DtInicial	datetime,
	@DtFinal	datetime,
	@Fornecedor varchar(20)
	)
as

	select distinct
		FC.Apelido Fornecedor, PGRT.Num_Lcto Lancamento, CX.Num_Proc_HIA Processo, TT.Nome_tp_tx Taxa,
		dbo.valor(CX.Vlr_Pgto_Rcto_HIA,CX.dc_hia)*-1 Valor_Taxa, CT.Titular Titular, Dt_Vcto Data, CX.DC_HIA DC
	from 
		pgto_rcto PGRT
		join vwcxas CX			on CX.Num_Lcto = PGRT.Num_Lcto 
		left join Pessoa FC		on FC.cd_Pes = PGRT.cd_pes
		left join Tipo_Taxa TT	on TT.cd_tp_Tx = CX.Cd_Tp_Tx
		left join Cta_Cte CT	on CT.Num_Cta_cte = PGRT.Num_Cta_Cte and CT.Cd_Banco = PGRT.Cd_Banco
	where
		PGRT.cd_pes like @Fornecedor and convert(datetime,Dt_Vcto,105) between @DtInicial and @DtFinal
union all

	select distinct
		FC.Apelido Fornecedor, PR.Num_Lcto_Div Lancamento, PR.Forma_Pgto_Rcto_Div Processo, PR.Num_Doc_Div Taxa,
		dbo.valor(PRD.Vlr_Item,PRD.DC_ITEM)*-1 Valor_Taxa, CT.Titular Titular, Dt_Vcto_Div Data, PRD.DC_Item DC
	from
		Pgto_Rcto_Div PR
		left join Pgto_Rcto_Div_Det PRD	on PRD.Num_Lcto_Div = PR.Num_Lcto_Div
		left join Pessoa FC				on FC.Cd_Pes = PR.Cd_Pes
		left join Cta_Cte CT			on CT.Num_cta_cte = PR.Num_Cta_Cte and CT.Cd_Banco = PR.Cd_Banco
	where
		PR.Cd_Pes like @Fornecedor and convert(datetime,Dt_Vcto_Div,105) between @DtInicial and @DtFinal

	order by 1






GO
