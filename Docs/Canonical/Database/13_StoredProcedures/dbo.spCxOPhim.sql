SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE     PROCEDURE spCxOPhim 

		@DataInicial	varchar(10),
		@DataFinal	varchar(10)
as


select Cta.NUM_PROC_him, nome_tp_tx, Cta.DC_him, apelido, cta.cd_tp_moeda as Moeda, cast(cta.vlr_org_him as money) as ValorCTA, Sum(opos.Vlr_ref_him) as ValorPG, Opos.Vlr_ref_him, opos.dt_pgto_rcto_him, OPOS.par_moeda_him, oposc.cd_tp_moeda, masopos.cd_tp_moeda as MasMOEDA, masoposc.par_moeda_mim, masoposc.dt_pgto_rcto_mim   from ctA_CTE_HOU_imp_mar as Cta
	
	join tipo_taxa on (cta.cd_tp_Tx=tipo_taxa.cd_tp_Tx)
	join pessoa on (cd_pes=cta.cd_cred_dev_him)
	left outer join caixa_hou_imp_mar as cxa on (cta.num_proc_him=CXA.num_proc_him and cta.cd_tp_tx=CXA.cd_tp_Tx and cta.dc_him=cxa.dc_him and cxa.num_lcto <> 'PROVISÓRIO' and convert(datetime, cxa.dt_pgto_rcto_him, 105)<=convert(Datetime, @DataFinal, 105))
	left outer join cta_cte_hou_imp_mar as oPOSc on (cta.num_proc_him=OPOSC.num_proc_him and cta.cd_tp_tx=OPOSC.cd_tp_Tx and cta.dc_him<>OPOSC.dc_him)
	left outer join caixa_hou_imp_mar as oPOS on (cta.num_proc_him=OPOS.num_proc_him and cta.cd_tp_tx=OPOS.cd_tp_Tx and cta.dc_him<>OPOS.dc_him and opos.num_lcto <> 'PROVISÓRIO' and convert(datetime, opos.dt_pgto_rcto_him, 105)<=convert(Datetime, @DataFinal, 105))
	left outer join cta_cte_mas_imp_mar as MasOpos on (left(cta.num_proc_him, 14)=masopos.num_proc_mim and cta.cd_tp_tx=masopos.cd_tp_tx and cta.dc_him <> masopos.dc_mim)	
	left outer join caixa_mas_imp_mar as MasOposC on ( masopos.num_proc_mim=masoposc.num_proc_mim and masopos.cd_tp_Tx=masoposc.cd_tp_tx and masopos.dc_mim=masoposc.dc_mim and masoposc.num_lcto <> 'PROVISÓRIO' and convert(datetime, masoposc.dt_pgto_rcto_mim, 105) <= convert(datetime, @Datafinal, 105)) 
where

	cxa.Vlr_ref_him is null  AND
	(opos.vlr_ref_him is not null or masoposc.vlr_ref_mim is not null)
	AND CONVERT(DATETIME, CTA.DT_INS_him, 105) between
	convert(datetime, @DataInicial, 105) and
	convert(datetime, @DataFinal, 105)
	and cta.desp_org_him='N'
group by 

	Cta.NUM_PROC_him, nome_tp_Tx, Cta.DC_him, cta.vlr_org_him, oPOS.Vlr_Ref_him, opos.dt_pgto_rcto_him, apelido
	, OPOS.par_moeda_him, oposc.cd_tp_moeda, cta.cd_tp_moeda , masopos.cd_tp_moeda , masoposc.par_moeda_mim, masoposc.dt_pgto_rcto_mim 


union

select Cta.NUM_PROC_mim, nome_tp_tx, Cta.DC_mim, apelido, cta.cd_tp_moeda as Moeda, cast(cta.vlr_org_mim as money) as ValorCTA, Sum(opos.Vlr_ref_mim) as ValorPG, Opos.Vlr_ref_mim, opos.dt_pgto_rcto_mim, OPOS.par_moeda_mim, oposc.cd_tp_moeda, masopos.cd_tp_moeda as MasMOEDA, masoposc.par_moeda_him, masoposc.dt_pgto_rcto_him   from ctA_CTE_mas_imp_mar as Cta
	
	join tipo_taxa on (cta.cd_tp_Tx=tipo_taxa.cd_tp_Tx)
	join pessoa on (cd_pes=cta.cd_cred_dev_mim)
	left outer join caixa_mas_imp_mar as cxa on (cta.num_proc_mim=CXA.num_proc_mim and cta.cd_tp_tx=CXA.cd_tp_Tx and cta.dc_mim=cxa.dc_mim and cxa.num_lcto <> 'PROVISÓRIO' and convert(datetime, cxa.dt_pgto_rcto_mim, 105)<=convert(Datetime, @DataFinal, 105))
	left outer join cta_cte_mas_imp_mar as oPOSc on (cta.num_proc_mim=OPOSC.num_proc_mim and cta.cd_tp_tx=OPOSC.cd_tp_Tx and cta.dc_mim<>OPOSC.dc_mim)
	left outer join caixa_mas_imp_mar as oPOS on (cta.num_proc_mim=OPOS.num_proc_mim and cta.cd_tp_tx=OPOS.cd_tp_Tx and cta.dc_mim<>OPOS.dc_mim and opos.num_lcto <> 'PROVISÓRIO' and convert(datetime, opos.dt_pgto_rcto_mim, 105)<=convert(Datetime, @DataFinal, 105))
	left outer join cta_cte_hou_imp_mar as MasOpos on (cta.num_proc_mim=left(masopos.num_proc_him,14) and cta.cd_tp_tx=masopos.cd_tp_tx and cta.dc_mim <> masopos.dc_him)	
	left outer join caixa_hou_imp_mar as MasOposC on ( masopos.num_proc_him=masoposc.num_proc_him and masopos.cd_tp_Tx=masoposc.cd_tp_tx and masopos.dc_him=masoposc.dc_him and masoposc.num_lcto <> 'PROVISÓRIO' and convert(datetime, masoposc.dt_pgto_rcto_him, 105) <= convert(datetime, @Datafinal, 105)) 
where

	cxa.Vlr_ref_mim is null  AND
	(opos.vlr_ref_mim is not null or masoposc.vlr_ref_him is not null)
	AND CONVERT(DATETIME, CTA.DT_INS_mim, 105) between
	convert(datetime, @DataInicial, 105) and
	convert(datetime, @DataFinal, 105)
	and cta.desp_org_mim='N'
group by 

	Cta.NUM_PROC_mim, nome_tp_Tx, Cta.DC_mim, cta.vlr_org_mim, oPOS.Vlr_Ref_mim, opos.dt_pgto_rcto_mim, apelido
	, OPOS.par_moeda_mim, oposc.cd_tp_moeda, cta.cd_tp_moeda , masopos.cd_tp_moeda , masoposc.par_moeda_him, masoposc.dt_pgto_rcto_him 




GO
