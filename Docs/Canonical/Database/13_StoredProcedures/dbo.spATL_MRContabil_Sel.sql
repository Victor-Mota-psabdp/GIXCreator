SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_MRContabil_Sel]
	@dataInicial	Datetime,
	@Datafinal		Datetime
as


select 	
	Left(cxa.Num_proc_HIa,2) Modal,

		Case left(apelido,3) 
		When 'BDP' then 'BDP'
		Else 'Other'
	end Tipo,
	Sum(vlr_pgto_rcto_hia) Valor,
	cxa.dc_hia DC,
	Left(Num_Lcto,1) Tipo_Financeiro
 from vwcxas CXA

Join vwcta_Cte cta on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_Tx and cta.dc_hia=cxa.dc_hia
Join Pessoa PP on pp.cd_pes=cd_Cred_dev_hia
left Join Base_Nota_Fiscal NF on num_nf_hia=notA_fiscal and ref_acesso_nf_hia=ref_Acesso
where convert(Datetime,dt_pgto_rcto_hia,105) between '12-01-2012' and '12-31-2012'

and nota_fiscal is null
AND cxa.CD_TP_TX NOT IN ('BRO','EF1','EF2','EF3','EF4','EF5','EFE','ERE','GPO','srv','TTC')
and left(cxa.cd_tp_tx,1) <> 'X' and left(cxa.cd_tp_tx,2)<>'DN'
Group  by
	Case left(apelido,3) 
		When 'BDP' then 'BDP'
		Else 'Other'
	end,
	cxa.dc_hia,
Left(Num_Lcto,1),
	Left(cxa.Num_proc_HIa,2)


union all


select 	
	'D',

		Case left(apelido,3) 
		When 'BDP' then 'BDP'
		Else 'Other'
	end,
	Sum(vlr_pgto_rcto_hia),
	cxa.dc_hia,
	Left(Num_Lcto,1)
 from vwcxas CXA

Join vwcta_Cte cta on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_Tx and cta.dc_hia=cxa.dc_hia
Join Pessoa PP on pp.cd_pes=cd_Cred_dev_hia
left Join Base_Nota_Fiscal NF on num_nf_hia=notA_fiscal and ref_acesso_nf_hia=ref_Acesso
where convert(Datetime,dt_pgto_rcto_hia,105) between '12-01-2012' and '12-31-2012'

and nota_fiscal is null
AND (cxa.CD_TP_TX IN ('BRO','EF1','EF2','EF3','EF4','EF5','EFE','ERE','GPO','srv','TTC') or left(cxa.cd_tp_tx,1) = 'X' or left(cxa.cd_tp_tx,2)='DN')
Group  by
	Case left(apelido,3) 
		When 'BDP' then 'BDP'
		Else 'Other'
	end,
	cxa.dc_hia,
Left(Num_Lcto,1),
	Left(cxa.Num_proc_HIa,2)


Union All


select 	
	 left(cta.num_proc_hia,2),

		Case left(apelido,3) 
		When 'BDP' then 'BDP'
		Else 'Other'
	end,
	Sum(vlr_pgto_nf_hia),
	cta.dc_hia,
	'NF'
 from vwcta_Cte cta
Join Pessoa PP on pp.cd_pes=cd_Cred_dev_hia
Join Base_Nota_Fiscal NF on num_nf_hia=notA_fiscal and ref_acesso_nf_hia=ref_Acesso
where Emissao  between '12-01-2012' and '12-31-2012'
AND (cta.CD_TP_TX IN ('BRO','EF1','EF2','EF3','EF4','EF5','EFE','ERE','GPO','srv','TTC') or left(cta.cd_tp_tx,1) = 'X' or left(cta.cd_tp_tx,2)='DN')
Group  by
	Case left(apelido,3) 
		When 'BDP' then 'BDP'
		Else 'Other'
	end,
	cta.dc_hia,
	Left(cta.Num_proc_HIa,2)


GO
