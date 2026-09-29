SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



CREATE       PROCEDURE spCxOPhem 

		@DataInicial	varchar(10),
		@DataFinal	varchar(10)
as


select Cta.NUM_PROC_hem, nome_tp_tx, Cta.DC_hem, apelido, cta.cd_tp_moeda as Moeda, cast(cta.vlr_org_hem as money) as ValorCTA, Sum(cxa.Vlr_ref_hem) as ValorPG, Opos.Vlr_ref_hem, opos.dt_pgto_rcto_hem, OPOS.par_moeda_hem  as ParHouse, oposc.cd_tp_moeda, masopos.cd_tp_moeda as MasMOEDA, masoposc.par_moeda_mem  as ParMASTER, masoposc.dt_pgto_rcto_mem   from ctA_CTE_HOU_EXP_mar as Cta
	
	join tipo_taxa on (cta.cd_tp_Tx=tipo_taxa.cd_tp_Tx)
	join pessoa on (cd_pes=cta.cd_cred_dev_hem)
	left outer join caixa_hou_EXP_mar as cxa on (cta.num_proc_hem=CXA.num_proc_hem and cta.cd_tp_tx=CXA.cd_tp_Tx and cta.dc_hem=cxa.dc_hem and cxa.num_lcto <> 'PROVISÓRIO' and convert(datetime, cxa.dt_pgto_rcto_hem, 105)<=convert(Datetime, @DataFinal, 105))
	left outer join cta_cte_hou_EXP_mar as oPOSc on (cta.num_proc_hem=OPOSC.num_proc_hem and cta.cd_tp_tx=OPOSC.cd_tp_Tx and cta.dc_hem<>OPOSC.dc_hem)
	left outer join caixa_hou_EXP_mar as oPOS on (cta.num_proc_hem=OPOS.num_proc_hem and cta.cd_tp_tx=OPOS.cd_tp_Tx and cta.dc_hem<>OPOS.dc_hem and opos.num_lcto <> 'PROVISÓRIO' and convert(datetime, opos.dt_pgto_rcto_hem, 105)<=convert(Datetime, @DataFinal, 105))
	left outer join cta_cte_mas_exp_mar as MasOpos on (left(cta.num_proc_hem, 14)=masopos.num_proc_mem and cta.cd_tp_tx=masopos.cd_tp_tx and cta.dc_hem <> masopos.dc_mem)	
	left outer join caixa_mas_exp_mar as MasOposC on ( masopos.num_proc_mem=masoposc.num_proc_mem and masopos.cd_tp_Tx=masoposc.cd_tp_tx and masopos.dc_mem=masoposc.dc_mem and masoposc.num_lcto <> 'PROVISÓRIO' and convert(datetime, masoposc.dt_pgto_rcto_mem, 105) <= convert(datetime, @Datafinal, 105)) 
where

	cxa.Vlr_ref_hem is null  AND
	(opos.vlr_ref_hem is not null or masoposc.vlr_ref_mem is not null)
	AND CONVERT(DATETIME, CTA.DT_INS_hem, 105) between
	convert(datetime, @DataInicial, 105) and
	convert(datetime, @DataFinal, 105)
	and cta.desp_dst_hem='N'
group by 

	Cta.NUM_PROC_hem, nome_tp_Tx, Cta.DC_hem, cta.vlr_org_hem, oPOS.Vlr_Ref_hem, opos.dt_pgto_rcto_hem, apelido
	, OPOS.par_moeda_hem, oposc.cd_tp_moeda, cta.cd_tp_moeda , masopos.cd_tp_moeda , masoposc.par_moeda_mem, masoposc.dt_pgto_rcto_mem 


union

select Cta.NUM_PROC_mem, nome_tp_tx, Cta.DC_mem, apelido, cta.cd_tp_moeda as Moeda, cast(cta.vlr_org_mem as money) as ValorCTA, Sum(cxa.Vlr_ref_mem) as ValorPG, Opos.Vlr_ref_mem, opos.dt_pgto_rcto_mem, OPOS.par_moeda_mem  as ParHouse, oposc.cd_tp_moeda, masopos.cd_tp_moeda as MasMOEDA, masoposc.par_moeda_hem  as ParMaster, masoposc.dt_pgto_rcto_hem   from ctA_CTE_mas_EXP_mar as Cta
	
	join tipo_taxa on (cta.cd_tp_Tx=tipo_taxa.cd_tp_Tx)
	join pessoa on (cd_pes=cta.cd_cred_dev_mem)
	left outer join caixa_mas_EXP_mar as cxa on (cta.num_proc_mem=CXA.num_proc_mem and cta.cd_tp_tx=CXA.cd_tp_Tx and cta.dc_mem=cxa.dc_mem and cxa.num_lcto <> 'PROVISÓRIO' and convert(datetime, cxa.dt_pgto_rcto_mem, 105)<=convert(Datetime, @DataFinal, 105))
	left outer join cta_cte_mas_EXP_mar as oPOSc on (cta.num_proc_mem=OPOSC.num_proc_mem and cta.cd_tp_tx=OPOSC.cd_tp_Tx and cta.dc_mem<>OPOSC.dc_mem)
	left outer join caixa_mas_EXP_mar as oPOS on (cta.num_proc_mem=OPOS.num_proc_mem and cta.cd_tp_tx=OPOS.cd_tp_Tx and cta.dc_mem<>OPOS.dc_mem and opos.num_lcto <> 'PROVISÓRIO' and convert(datetime, opos.dt_pgto_rcto_mem, 105)<=convert(Datetime, @DataFinal, 105))
	left outer join cta_cte_hou_exp_mar as MasOpos on (cta.num_proc_mem=left(masopos.num_proc_hem,14) and cta.cd_tp_tx=masopos.cd_tp_tx and cta.dc_mem <> masopos.dc_hem)	
	left outer join caixa_hou_exp_mar as MasOposC on ( masopos.num_proc_hem=masoposc.num_proc_hem and masopos.cd_tp_Tx=masoposc.cd_tp_tx and masopos.dc_hem=masoposc.dc_hem and masoposc.num_lcto <> 'PROVISÓRIO' and convert(datetime, masoposc.dt_pgto_rcto_hem, 105) <= convert(datetime, @Datafinal, 105)) 
where

	cxa.Vlr_ref_mem is null  AND
	(opos.vlr_ref_mem is not null or masoposc.vlr_ref_hem is not null)
	AND CONVERT(DATETIME, CTA.DT_INS_mem, 105) between
	convert(datetime, @DataInicial, 105) and
	convert(datetime, @DataFinal, 105)
	and cta.desp_dst_mem='N'
group by 

	Cta.NUM_PROC_mem, nome_tp_Tx, Cta.DC_mem, cta.vlr_org_mem, oPOS.Vlr_Ref_mem, opos.dt_pgto_rcto_mem, apelido
	, OPOS.par_moeda_mem, oposc.cd_tp_moeda, cta.cd_tp_moeda , masopos.cd_tp_moeda , masoposc.par_moeda_hem, masoposc.dt_pgto_rcto_hem 










GO
