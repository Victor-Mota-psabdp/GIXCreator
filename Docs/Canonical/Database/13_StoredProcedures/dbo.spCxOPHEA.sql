SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE     PROCEDURE spCxOPHEA 

		@DataInicial	varchar(10),
		@DataFinal	varchar(10)
as


select Cta.NUM_PROC_HEA, nome_tp_tx, Cta.DC_HEA, apelido, cta.cd_tp_moeda as Moeda, cast(cta.vlr_org_HEA as money) as ValorCTA, Sum(cxa.Vlr_ref_HEA) as ValorPG, Opos.Vlr_ref_HEA, opos.dt_pgto_rcto_HEA, OPOS.par_moeda_HEA, oposc.cd_tp_moeda, masopos.cd_tp_moeda as MasMOEDA, masoposc.par_moeda_mea, masoposc.dt_pgto_rcto_mea   from ctA_CTE_HOU_EXP_aER as Cta
	
	join tipo_taxa on (cta.cd_tp_Tx=tipo_taxa.cd_tp_Tx)
	join pessoa on (cd_pes=cta.cd_cred_dev_HEA)
	left outer join caixa_hou_EXP_Aer as cxa on (cta.num_proc_HEA=CXA.num_proc_HEA and cta.cd_tp_tx=CXA.cd_tp_Tx and cta.dc_HEA=cxa.dc_HEA and cxa.num_lcto <> 'PROVISÓRIO' and convert(datetime, cxa.dt_pgto_rcto_HEA, 105)<=convert(Datetime, @DataFinal, 105))
	left outer join cta_cte_hou_EXP_Aer as oPOSc on (cta.num_proc_HEA=OPOSC.num_proc_HEA and cta.cd_tp_tx=OPOSC.cd_tp_Tx and cta.dc_HEA<>OPOSC.dc_HEA)
	left outer join caixa_hou_EXP_Aer as oPOS on (cta.num_proc_HEA=OPOS.num_proc_HEA and cta.cd_tp_tx=OPOS.cd_tp_Tx and cta.dc_HEA<>OPOS.dc_HEA and opos.num_lcto <> 'PROVISÓRIO' and convert(datetime, opos.dt_pgto_rcto_HEA, 105)<=convert(Datetime, @DataFinal, 105))
	left outer join cta_cte_mas_exp_aer as MasOpos on (left(cta.num_proc_hea, 14)=masopos.num_proc_mea and cta.cd_tp_tx=masopos.cd_tp_tx and cta.dc_hea <> masopos.dc_mea)	
	left outer join caixa_mas_exp_aer as MasOposC on ( masopos.num_proc_mea=masoposc.num_proc_mea and masopos.cd_tp_Tx=masoposc.cd_tp_tx and masopos.dc_mea=masoposc.dc_mea and masoposc.num_lcto <> 'PROVISÓRIO' and convert(datetime, masoposc.dt_pgto_rcto_mea, 105) <= convert(datetime, @Datafinal, 105)) 
where

	cxa.Vlr_ref_HEA is null  AND
	(opos.vlr_ref_HEA is not null or masoposc.vlr_ref_mea is not null)
	AND CONVERT(DATETIME, CTA.DT_INS_HEA, 105) between
	convert(datetime, @DataInicial, 105) and
	convert(datetime, @DataFinal, 105)
	and cta.desp_dst_hea='N'
group by 

	Cta.NUM_PROC_HEA, nome_tp_Tx, Cta.DC_HEA, cta.vlr_org_HEA, oPOS.Vlr_Ref_HEA, opos.dt_pgto_rcto_HEA, apelido
	, OPOS.par_moeda_HEA, oposc.cd_tp_moeda, cta.cd_tp_moeda , masopos.cd_tp_moeda , masoposc.par_moeda_mea, masoposc.dt_pgto_rcto_mea 


union

select Cta.NUM_PROC_MEA, nome_tp_tx, Cta.DC_MEA, apelido, cta.cd_tp_moeda as Moeda, cast(cta.vlr_org_MEA as money) as ValorCTA, Sum(cxa.Vlr_ref_MEA) as ValorPG, Opos.Vlr_ref_MEA, opos.dt_pgto_rcto_MEA, OPOS.par_moeda_MEA, oposc.cd_tp_moeda, masopos.cd_tp_moeda as MasMOEDA, masoposc.par_moeda_hea, masoposc.dt_pgto_rcto_hea   from ctA_CTE_mas_EXP_aER as Cta
	
	join tipo_taxa on (cta.cd_tp_Tx=tipo_taxa.cd_tp_Tx)
	join pessoa on (cd_pes=cta.cd_cred_dev_mEA)
	left outer join caixa_mas_EXP_Aer as cxa on (cta.num_proc_mEA=CXA.num_proc_mEA and cta.cd_tp_tx=CXA.cd_tp_Tx and cta.dc_mEA=cxa.dc_mEA and cxa.num_lcto <> 'PROVISÓRIO' and convert(datetime, cxa.dt_pgto_rcto_mEA, 105)<=convert(Datetime, @DataFinal, 105))
	left outer join cta_cte_mas_EXP_Aer as oPOSc on (cta.num_proc_mEA=OPOSC.num_proc_mEA and cta.cd_tp_tx=OPOSC.cd_tp_Tx and cta.dc_MEA<>OPOSC.dc_MEA)
	left outer join caixa_mas_EXP_Aer as oPOS on (cta.num_proc_mEA=OPOS.num_proc_mEA and cta.cd_tp_tx=OPOS.cd_tp_Tx and cta.dc_mEA<>OPOS.dc_mEA and opos.num_lcto <> 'PROVISÓRIO' and convert(datetime, opos.dt_pgto_rcto_mEA, 105)<=convert(Datetime, @DataFinal, 105))
	left outer join cta_cte_hou_exp_aer as MasOpos on (cta.num_proc_mea=left(masopos.num_proc_hea,14) and cta.cd_tp_tx=masopos.cd_tp_tx and cta.dc_mea <> masopos.dc_hea)	
	left outer join caixa_hou_exp_aer as MasOposC on ( masopos.num_proc_hea=masoposc.num_proc_hea and masopos.cd_tp_Tx=masoposc.cd_tp_tx and masopos.dc_hea=masoposc.dc_hea and masoposc.num_lcto <> 'PROVISÓRIO' and convert(datetime, masoposc.dt_pgto_rcto_hea, 105) <= convert(datetime, @Datafinal, 105)) 
where

	cxa.Vlr_ref_mEA is null  AND
	(opos.vlr_ref_mEA is not null or masoposc.vlr_ref_hea is not null)
	AND CONVERT(DATETIME, CTA.DT_INS_mEA, 105) between
	convert(datetime, @DataInicial, 105) and
	convert(datetime, @DataFinal, 105)
	and cta.desp_dst_mea='N'
group by 

	Cta.NUM_PROC_mEA, nome_tp_Tx, Cta.DC_mEA, cta.vlr_org_mEA, oPOS.Vlr_Ref_mEA, opos.dt_pgto_rcto_mEA, apelido
	, OPOS.par_moeda_mEA, oposc.cd_tp_moeda, cta.cd_tp_moeda , masopos.cd_tp_moeda , masoposc.par_moeda_hea, masoposc.dt_pgto_rcto_hea 






GO
