SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  PROCEDURE spCxOPsREL 

		@DataInicial	varchar(10),
		@DataFinal	varchar(10)
as

select Cta.NUM_PROC_HIA, nome_tp_tx, Cta.DC_HIA, apelido, cta.cd_tp_moeda as Moeda, cta.vlr_org_hia, Sum(cxa.Vlr_ref_hia) as ValorPG, Opos.Vlr_ref_hia, opos.dt_pgto_rcto_hia, OPOS.par_moeda_hia, oposc.cd_tp_moeda from ctA_CTE_HOU_IMP_aER as Cta
	
	join tipo_taxa on (cta.cd_tp_Tx=tipo_taxa.cd_tp_Tx)
	join pessoa on (cd_pes=cta.cd_cred_dev_hia)
	left outer join caixa_hou_imp_Aer as cxa on (cta.num_proc_hia=CXA.num_proc_hia and cta.cd_tp_tx=CXA.cd_tp_Tx and cta.dc_hia=cxa.dc_hia and cxa.num_lcto <> 'PROVISÓRIO' and convert(datetime, cxa.dt_pgto_rcto_hia, 105)<=convert(Datetime, @DataFinal, 105))
	left outer join cta_cte_hou_imp_Aer as oPOSc on (cta.num_proc_hia=OPOSC.num_proc_hia and cta.cd_tp_tx=OPOSC.cd_tp_Tx and cta.dc_hia<>OPOSC.dc_hia)
	left outer join caixa_hou_imp_Aer as oPOS on (cta.num_proc_hia=OPOS.num_proc_hia and cta.cd_tp_tx=OPOS.cd_tp_Tx and cta.dc_hia<>OPOS.dc_hia and opos.num_lcto <> 'PROVISÓRIO' and convert(datetime, opos.dt_pgto_rcto_hia, 105)<=convert(Datetime, @DataFinal, 105))
	
where

	cxa.Vlr_ref_hia is null  AND
	opos.vlr_ref_hia is not null
	AND CONVERT(DATETIME, CTA.DT_INS_HIA, 105) between
	convert(datetime, @DataInicial, 105) and
	convert(datetime, @DataFinal, 105) and
	cta.desp_org_hia ='N'
	
group by 

	Cta.NUM_PROC_HIA, nome_tp_Tx, Cta.DC_HIA, cta.vlr_org_hia, oPOS.Vlr_Ref_HIA, opos.dt_pgto_rcto_hia, apelido
	, OPOS.par_moeda_hia, oposc.cd_tp_moeda, cta.cd_tp_moeda


Union

select Cta.NUM_PROC_mia, nome_tp_tx, Cta.DC_mia, apelido, cta.cd_tp_moeda as Moeda,cta.vlr_org_mia, Sum(cxa.Vlr_ref_mia) as ValorPG, Opos.Vlr_ref_mia, opos.dt_pgto_rcto_mia, OPOS.par_moeda_mia, oposc.cd_tp_moeda from ctA_CTE_mas_IMP_aER as Cta
	
	join tipo_taxa on (cta.cd_tp_Tx=tipo_taxa.cd_tp_Tx)
	join pessoa on (cd_pes=cta.cd_cred_dev_mia)
	left outer join caixa_mas_imp_Aer as cxa on (cta.num_proc_mia=CXA.num_proc_mia and cta.cd_tp_tx=CXA.cd_tp_Tx and cta.dc_mia=cxa.dc_mia and cxa.num_lcto <> 'PROVISÓRIO' and convert(datetime, cxa.dt_pgto_rcto_mia, 105)<=convert(Datetime, @DataFinal, 105))
	left outer join cta_cte_mas_imp_Aer as oPOSc on (cta.num_proc_mia=OPOSC.num_proc_mia and cta.cd_tp_tx=OPOSC.cd_tp_Tx and cta.dc_mia<>OPOSC.dc_mia)
	left outer join caixa_mas_imp_Aer as oPOS on (cta.num_proc_mia=OPOS.num_proc_mia and cta.cd_tp_tx=OPOS.cd_tp_Tx and cta.dc_mia<>OPOS.dc_mia and opos.num_lcto <> 'PROVISÓRIO' AND CONVERT(DATETIME, OPOS.dt_pgto_rcto_MIA, 105) <= convert(DateTime, @DataFinal, 105))
	
where

	cxa.Vlr_ref_mia is null  AND
	opos.vlr_ref_mia is not null
	AND CONVERT(DATETIME, CTA.DT_INS_mia, 105) between
	convert(datetime, @DataInicial, 105) and
	convert(datetime, @DataFinal, 105)
	and cta.desp_org_mia = 'N'
group by 

	Cta.NUM_PROC_mia, nome_tp_Tx, Cta.DC_mia, cta.vlr_org_mia, oPOS.Vlr_Ref_mia, opos.dt_pgto_rcto_mia, apelido
	, OPOS.par_moeda_mia, oposc.cd_tp_moeda, cta.cd_tp_moeda

union

select Cta.NUM_PROC_HEA, nome_tp_tx, Cta.DC_HEA, apelido, cta.cd_tp_moeda as Moeda, cta.vlr_org_HEA, Sum(cxa.Vlr_ref_HEA) as ValorPG, Opos.Vlr_ref_HEA, opos.dt_pgto_rcto_HEA, OPOS.par_moeda_HEA, oposc.cd_tp_moeda from ctA_CTE_HOU_EXP_aER as Cta
	
	join tipo_taxa on (cta.cd_tp_Tx=tipo_taxa.cd_tp_Tx)
	join pessoa on (cd_pes=cta.cd_cred_dev_HEA)
	left outer join caixa_hou_EXP_Aer as cxa on (cta.num_proc_HEA=CXA.num_proc_HEA and cta.cd_tp_tx=CXA.cd_tp_Tx and cta.dc_HEA=cxa.dc_HEA and cxa.num_lcto <> 'PROVISÓRIO' and convert(datetime, cxa.dt_pgto_rcto_HEA, 105)<=convert(Datetime, @DataFinal, 105))
	left outer join cta_cte_hou_EXP_Aer as oPOSc on (cta.num_proc_HEA=OPOSC.num_proc_HEA and cta.cd_tp_tx=OPOSC.cd_tp_Tx and cta.dc_HEA<>OPOSC.dc_HEA)
	left outer join caixa_hou_EXP_Aer as oPOS on (cta.num_proc_HEA=OPOS.num_proc_HEA and cta.cd_tp_tx=OPOS.cd_tp_Tx and cta.dc_HEA<>OPOS.dc_HEA and opos.num_lcto <> 'PROVISÓRIO' and convert(datetime, opos.dt_pgto_rcto_HEA, 105)<=convert(Datetime, @DataFinal, 105))
	
where

	cxa.Vlr_ref_HEA is null  AND
	opos.vlr_ref_HEA is not null
	AND CONVERT(DATETIME, CTA.DT_INS_HEA, 105) between
	convert(datetime, @DataInicial, 105) and
	convert(datetime, @DataFinal, 105)
	and cta.desp_dst_hea='N'
group by 

	Cta.NUM_PROC_HEA, nome_tp_Tx, Cta.DC_HEA, cta.vlr_org_HEA, oPOS.Vlr_Ref_HEA, opos.dt_pgto_rcto_HEA, apelido
	, OPOS.par_moeda_HEA, oposc.cd_tp_moeda, cta.cd_tp_moeda


UNION


select Cta.NUM_PROC_mea, nome_tp_tx, Cta.DC_mea, apelido, cta.cd_tp_moeda as Moeda, cta.vlr_org_mea, Sum(cxa.Vlr_ref_mea) as ValorPG, Opos.Vlr_ref_mea, opos.dt_pgto_rcto_mea, OPOS.par_moeda_mea, oposc.cd_tp_moeda from ctA_CTE_mas_exp_aER as Cta
	
	join tipo_taxa on (cta.cd_tp_Tx=tipo_taxa.cd_tp_Tx)
	join pessoa on (cd_pes=cta.cd_cred_dev_mea)
	left outer join caixa_mas_exp_Aer as cxa on (cta.num_proc_mea=CXA.num_proc_mea and cta.cd_tp_tx=CXA.cd_tp_Tx and cta.dc_mea=cxa.dc_mea and cxa.num_lcto <> 'PROVISÓRIO' and convert(datetime, cxa.dt_pgto_rcto_mea, 105)<=convert(Datetime, @DataFinal, 105))
	left outer join cta_cte_mas_exp_Aer as oPOSc on (cta.num_proc_mea=OPOSC.num_proc_mea and cta.cd_tp_tx=OPOSC.cd_tp_Tx and cta.dc_mea<>OPOSC.dc_mea)
	left outer join caixa_mas_exp_Aer as oPOS on (cta.num_proc_mea=OPOS.num_proc_mea and cta.cd_tp_tx=OPOS.cd_tp_Tx and cta.dc_mea<>OPOS.dc_mea and opos.num_lcto <> 'PROVISÓRIO' AND CONVERT(DATETIME, OPOS.dt_pgto_rcto_mea, 105) <= convert(DateTime, @DataFinal, 105))
	
where

	cxa.Vlr_ref_mea is null  AND
	opos.vlr_ref_mea is not null
	AND CONVERT(DATETIME, CTA.DT_INS_mea, 105) between
	convert(datetime, @DataInicial, 105) and
	convert(datetime, @DataFinal, 105) 
		and cta.desp_dst_mea='N'	
group by 

	Cta.NUM_PROC_mea, nome_tp_Tx, Cta.DC_mea, cta.vlr_org_mea, oPOS.Vlr_Ref_mea, opos.dt_pgto_rcto_mea, apelido
	, OPOS.par_moeda_mea, oposc.cd_tp_moeda, cta.cd_tp_moeda

UNION

select Cta.NUM_PROC_HIM, nome_tp_tx, Cta.DC_HIM, apelido, cta.cd_tp_moeda as Moeda, cta.vlr_org_HIM, Sum(cxa.Vlr_ref_HIM) as ValorPG, Opos.Vlr_ref_HIM, opos.dt_pgto_rcto_HIM, OPOS.par_moeda_HIM, oposc.cd_tp_moeda from ctA_CTE_HOU_IMP_MAR as Cta
	
	join tipo_taxa on (cta.cd_tp_Tx=tipo_taxa.cd_tp_Tx)
	join pessoa on (cd_pes=cta.cd_cred_dev_HIM)
	left outer join caixa_hou_imp_MAR as cxa on (cta.num_proc_HIM=CXA.num_proc_HIM and cta.cd_tp_tx=CXA.cd_tp_Tx and cta.dc_HIM=cxa.dc_HIM and cxa.num_lcto <> 'PROVISÓRIO' and convert(datetime, cxa.dt_pgto_rcto_HIM, 105)<=convert(Datetime, @DataFinal, 105))
	left outer join cta_cte_hou_imp_MAR as oPOSc on (cta.num_proc_HIM=OPOSC.num_proc_HIM and cta.cd_tp_tx=OPOSC.cd_tp_Tx and cta.dc_HIM<>OPOSC.dc_HIM)
	left outer join caixa_hou_imp_MAR as oPOS on (cta.num_proc_HIM=OPOS.num_proc_HIM and cta.cd_tp_tx=OPOS.cd_tp_Tx and cta.dc_HIM<>OPOS.dc_HIM and opos.num_lcto <> 'PROVISÓRIO' and convert(datetime, opos.dt_pgto_rcto_HIM, 105)<=convert(Datetime, @DataFinal, 105))
	
where

	cxa.Vlr_ref_HIM is null  AND
	opos.vlr_ref_HIM is not null
	AND CONVERT(DATETIME, CTA.DT_INS_HIM, 105) between
	convert(datetime, @DataInicial, 105) and
	convert(datetime, @DataFinal, 105)
	and cta.desp_org_him = 'N'	
group by 

	Cta.NUM_PROC_HIM, nome_tp_Tx, Cta.DC_HIM, cta.vlr_org_HIM, oPOS.Vlr_Ref_HIM, opos.dt_pgto_rcto_HIM, apelido
	, OPOS.par_moeda_HIM, oposc.cd_tp_moeda, cta.cd_tp_moeda


UNION

select Cta.NUM_PROC_MIM, nome_tp_tx, Cta.DC_MIM, apelido, cta.cd_tp_moeda as Moeda, cta.vlr_org_MIM, Sum(cxa.Vlr_ref_MIM) as ValorPG, Opos.Vlr_ref_MIM, opos.dt_pgto_rcto_MIM, OPOS.par_moeda_MIM, oposc.cd_tp_moeda from ctA_CTE_mas_IMP_MAR as Cta
	
	join tipo_taxa on (cta.cd_tp_Tx=tipo_taxa.cd_tp_Tx)
	join pessoa on (cd_pes=cta.cd_cred_dev_MIM)
	left outer join caixa_mas_imp_MAR as cxa on (cta.num_proc_MIM=CXA.num_proc_MIM and cta.cd_tp_tx=CXA.cd_tp_Tx and cta.dc_MIM=cxa.dc_MIM and cxa.num_lcto <> 'PROVISÓRIO' and convert(datetime, cxa.dt_pgto_rcto_MIM, 105)<=convert(Datetime, @DataFinal, 105))
	left outer join cta_cte_mas_imp_MAR as oPOSc on (cta.num_proc_MIM=OPOSC.num_proc_MIM and cta.cd_tp_tx=OPOSC.cd_tp_Tx and cta.dc_MIM<>OPOSC.dc_MIM)
	left outer join caixa_mas_imp_MAR as oPOS on (cta.num_proc_MIM=OPOS.num_proc_MIM and cta.cd_tp_tx=OPOS.cd_tp_Tx and cta.dc_MIM<>OPOS.dc_MIM and opos.num_lcto <> 'PROVISÓRIO' AND CONVERT(DATETIME, OPOS.dt_pgto_rcto_MIM, 105) <= convert(DateTime, @DataFinal, 105))
	
where

	cxa.Vlr_ref_MIM is null  AND
	opos.vlr_ref_MIM is not null
	AND CONVERT(DATETIME, CTA.DT_INS_MIM, 105) between
	convert(datetime, @DataInicial, 105) and
	convert(datetime, @DataFinal, 105)
	and cta.desp_org_mim='N'	
group by 

	Cta.NUM_PROC_MIM, nome_tp_Tx, Cta.DC_MIM, cta.vlr_org_MIM, oPOS.Vlr_Ref_MIM, opos.dt_pgto_rcto_MIM, apelido
	, OPOS.par_moeda_MIM, oposc.cd_tp_moeda, cta.cd_tp_moeda

union

select Cta.NUM_PROC_HEM, nome_tp_tx, Cta.DC_HEM, apelido, cta.cd_tp_moeda as Moeda, cta.vlr_org_HEM, Sum(cxa.Vlr_ref_HEM) as ValorPG, Opos.Vlr_ref_HEM, opos.dt_pgto_rcto_HEM, OPOS.par_moeda_HEM, oposc.cd_tp_moeda from ctA_CTE_HOU_EXP_MAR as Cta
	
	join tipo_taxa on (cta.cd_tp_Tx=tipo_taxa.cd_tp_Tx)
	join pessoa on (cd_pes=cta.cd_cred_dev_HEM)
	left outer join caixa_hou_EXP_MAR as cxa on (cta.num_proc_HEM=CXA.num_proc_HEM and cta.cd_tp_tx=CXA.cd_tp_Tx and cta.dc_HEM=cxa.dc_HEM and cxa.num_lcto <> 'PROVISÓRIO' and convert(datetime, cxa.dt_pgto_rcto_HEM, 105)<=convert(Datetime, @DataFinal, 105))
	left outer join cta_cte_hou_EXP_MAR as oPOSc on (cta.num_proc_HEM=OPOSC.num_proc_HEM and cta.cd_tp_tx=OPOSC.cd_tp_Tx and cta.dc_HEM<>OPOSC.dc_HEM)
	left outer join caixa_hou_EXP_MAR as oPOS on (cta.num_proc_HEM=OPOS.num_proc_HEM and cta.cd_tp_tx=OPOS.cd_tp_Tx and cta.dc_HEM<>OPOS.dc_HEM and opos.num_lcto <> 'PROVISÓRIO' and convert(datetime, opos.dt_pgto_rcto_HEM, 105)<=convert(Datetime, @DataFinal, 105))
		
where

	cxa.Vlr_ref_HEM is null  AND
	opos.vlr_ref_HEM is not null
	AND CONVERT(DATETIME, CTA.DT_INS_HEM, 105) between
	convert(datetime, @DataInicial, 105) and
	convert(datetime, @DataFinal, 105)
	and cta.desp_dst_hem='N'	
group by 

	Cta.NUM_PROC_HEM, nome_tp_Tx, Cta.DC_HEM, cta.vlr_org_HEM, oPOS.Vlr_Ref_HEM, opos.dt_pgto_rcto_HEM, apelido
	, OPOS.par_moeda_HEM, oposc.cd_tp_moeda, cta.cd_tp_moeda

union

select Cta.NUM_PROC_mem, nome_tp_tx, Cta.DC_mem, apelido, cta.cd_tp_moeda as Moeda,cta.vlr_org_mem, Sum(cxa.Vlr_ref_mem) as ValorPG, Opos.Vlr_ref_mem, opos.dt_pgto_rcto_mem, OPOS.par_moeda_mem, oposc.cd_tp_moeda from ctA_CTE_mas_exp_mar as Cta
	
	join tipo_taxa on (cta.cd_tp_Tx=tipo_taxa.cd_tp_Tx)
	join pessoa on (cd_pes=cta.cd_cred_dev_mem)
	left outer join caixa_mas_exp_mar as cxa on (cta.num_proc_mem=CXA.num_proc_mem and cta.cd_tp_tx=CXA.cd_tp_Tx and cta.dc_mem=cxa.dc_mem and cxa.num_lcto <> 'PROVISÓRIO' and convert(datetime, cxa.dt_pgto_rcto_mem, 105)<=convert(Datetime, @DataFinal, 105))
	left outer join cta_cte_mas_exp_mar as oPOSc on (cta.num_proc_mem=OPOSC.num_proc_mem and cta.cd_tp_tx=OPOSC.cd_tp_Tx and cta.dc_mem<>OPOSC.dc_mem)
	left outer join caixa_mas_exp_mar as oPOS on (cta.num_proc_mem=OPOS.num_proc_mem and cta.cd_tp_tx=OPOS.cd_tp_Tx and cta.dc_mem<>OPOS.dc_mem and opos.num_lcto <> 'PROVISÓRIO' AND CONVERT(DATETIME, OPOS.dt_pgto_rcto_mem, 105) <= convert(DateTime, @DataFinal, 105))
	
where

	cxa.Vlr_ref_mem is null  AND
	opos.vlr_ref_mem is not null
	AND CONVERT(DATETIME, CTA.DT_INS_mem, 105) between
	convert(datetime, @DataInicial, 105) and
	convert(datetime, @DataFinal, 105) and
	cta.desp_dst_mem='N'	

group by 

	Cta.NUM_PROC_mem, nome_tp_Tx, Cta.DC_mem, cta.vlr_org_mem, oPOS.Vlr_Ref_mem, opos.dt_pgto_rcto_mem, apelido
	, OPOS.par_moeda_mem, oposc.cd_tp_moeda, cta.cd_tp_moeda



GO
