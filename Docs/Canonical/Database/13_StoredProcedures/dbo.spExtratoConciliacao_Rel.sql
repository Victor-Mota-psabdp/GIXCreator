SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spExtratoConciliacao_Rel]--'MA2010030147'

(
	@Processo varchar(12)
)
AS

select 
	RCC.num_lcto_mov			num_lcto_mov,
	num_lcto_rec				num_lcto_rec,
	MCC.Dt_Pgto_Rcto_Mov		Fecha,
	MCC.vlr_doc_mov				saldo_ma,
	MCC.Historico				Concepto,
	MCC.DC_Mov					DC,
	isnull(P.Apelido,PP.Apelido) Provedor,
	cu.nome_Centro_custo		Centro_custo
from rec_cta_cte RCC	
	join mvto_cta_cte MCC on RCC.Num_lcto_mov=MCC.num_lcto_mov
	join cta_cte CC on CC.Num_cta_cte=MCC.num_cta_cte
	left join Pgto_rcto  PR on PR.num_lcto = RCC.num_lcto_rec
	left join Pgto_rcto_div PRD on PRD.num_lcto_div = RCC.num_lcto_rec
	left join centro_custo CU on cu.cd_centro_custo = pr.cd_centro_custo
	left join Pessoa P on P.cd_pes = Pr.cd_pes
	left join Pessoa PP on PP.cd_pes = PRD.cd_pes
where  
	RCC.num_lcto_mov = @Processo	
group by
	 RCC.num_lcto_mov,num_lcto_rec,num_lcto_rec,mcc.Dt_Pgto_Rcto_Mov,
	mcc.vlr_doc_mov,mcc.Historico,mcc.DC_Mov,P.Apelido,PP.Apelido,
	cu.nome_Centro_custo
order by
	RCC.num_lcto_mov
GO
