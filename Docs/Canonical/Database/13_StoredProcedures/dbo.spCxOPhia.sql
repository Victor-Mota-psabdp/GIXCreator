SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE      PROCEDURE spCxOPhia 

		@DataInicial	varchar(10),
		@DataFinal	varchar(10)
as


select Cta.NUM_PROC_hia, nome_tp_tx, Cta.DC_hia, apelido, cta.cd_tp_moeda as Moeda, cast(cta.vlr_org_hia as money) as ValorCTA, Sum(cxa.Vlr_ref_hia) as ValorPG, Opos.Vlr_ref_hia, opos.dt_pgto_rcto_hia, OPOS.par_moeda_hia  as ParHouse, oposc.cd_tp_moeda, masopos.cd_tp_moeda as MasMOEDA, masoposc.par_moeda_mia  as ParMaster, masoposc.dt_pgto_rcto_mia   from ctA_CTE_HOU_imp_aER as Cta
	
	join tipo_taxa on (cta.cd_tp_Tx=tipo_taxa.cd_tp_Tx)
	join pessoa on (cd_pes=cta.cd_cred_dev_hia)
	left outer join caixa_hou_imp_Aer as cxa on (cta.num_proc_hia=CXA.num_proc_hia and cta.cd_tp_tx=CXA.cd_tp_Tx and cta.dc_hia=cxa.dc_hia and cxa.num_lcto <> 'PROVISÓRIO' and convert(datetime, cxa.dt_pgto_rcto_hia, 105)<=convert(Datetime, @DataFinal, 105))
	left outer join cta_cte_hou_imp_Aer as oPOSc on (cta.num_proc_hia=OPOSC.num_proc_hia and cta.cd_tp_tx=OPOSC.cd_tp_Tx and cta.dc_hia<>OPOSC.dc_hia)
	left outer join caixa_hou_imp_Aer as oPOS on (cta.num_proc_hia=OPOS.num_proc_hia and cta.cd_tp_tx=OPOS.cd_tp_Tx and cta.dc_hia<>OPOS.dc_hia and opos.num_lcto <> 'PROVISÓRIO' and convert(datetime, opos.dt_pgto_rcto_hia, 105)<=convert(Datetime, @DataFinal, 105))
	left outer join cta_cte_mas_imp_aer as MasOpos on (left(cta.num_proc_hia, 14)=masopos.num_proc_mia and cta.cd_tp_tx=masopos.cd_tp_tx and cta.dc_hia <> masopos.dc_mia)	
	left outer join caixa_mas_imp_aer as MasOposC on ( masopos.num_proc_mia=masoposc.num_proc_mia and masopos.cd_tp_Tx=masoposc.cd_tp_tx and masopos.dc_mia=masoposc.dc_mia and masoposc.num_lcto <> 'PROVISÓRIO' and convert(datetime, masoposc.dt_pgto_rcto_mia, 105) <= convert(datetime, @Datafinal, 105)) 
where

	cxa.Vlr_ref_hia is null  AND
	(opos.vlr_ref_hia is not null or masoposc.vlr_ref_mia is not null)
	AND CONVERT(DATETIME, CTA.DT_INS_hia, 105) between
	convert(datetime, @DataInicial, 105) and
	convert(datetime, @DataFinal, 105)
	and cta.desp_org_hia='N'
group by 

	Cta.NUM_PROC_hia, nome_tp_Tx, Cta.DC_hia, cta.vlr_org_hia, oPOS.Vlr_Ref_hia, opos.dt_pgto_rcto_hia, apelido
	, OPOS.par_moeda_hia, oposc.cd_tp_moeda, cta.cd_tp_moeda , masopos.cd_tp_moeda , masoposc.par_moeda_mia, masoposc.dt_pgto_rcto_mia 


union

select Cta.NUM_PROC_mia, nome_tp_tx, Cta.DC_mia, apelido, cta.cd_tp_moeda as Moeda, cast(cta.vlr_org_mia as money) as ValorCTA, Sum(cxa.Vlr_ref_mia) as ValorPG, Opos.Vlr_ref_mia, opos.dt_pgto_rcto_mia, OPOS.par_moeda_mia  as ParMaster, oposc.cd_tp_moeda, masopos.cd_tp_moeda as MasMOEDA, masoposc.par_moeda_hia  as ParMaster, masoposc.dt_pgto_rcto_hia   from ctA_CTE_mas_imp_aER as Cta
	
	join tipo_taxa on (cta.cd_tp_Tx=tipo_taxa.cd_tp_Tx)
	join pessoa on (cd_pes=cta.cd_cred_dev_mia)
	left outer join caixa_mas_imp_Aer as cxa on (cta.num_proc_mia=CXA.num_proc_mia and cta.cd_tp_tx=CXA.cd_tp_Tx and cta.dc_mia=cxa.dc_mia and cxa.num_lcto <> 'PROVISÓRIO' and convert(datetime, cxa.dt_pgto_rcto_mia, 105)<=convert(Datetime, @DataFinal, 105))
	left outer join cta_cte_mas_imp_Aer as oPOSc on (cta.num_proc_mia=OPOSC.num_proc_mia and cta.cd_tp_tx=OPOSC.cd_tp_Tx and cta.dc_mia<>OPOSC.dc_mia)
	left outer join caixa_mas_imp_Aer as oPOS on (cta.num_proc_mia=OPOS.num_proc_mia and cta.cd_tp_tx=OPOS.cd_tp_Tx and cta.dc_mia<>OPOS.dc_mia and opos.num_lcto <> 'PROVISÓRIO' and convert(datetime, opos.dt_pgto_rcto_mia, 105)<=convert(Datetime, @DataFinal, 105))
	left outer join cta_cte_hou_imp_aer as MasOpos on (cta.num_proc_mia=left(masopos.num_proc_hia,14) and cta.cd_tp_tx=masopos.cd_tp_tx and cta.dc_mia <> masopos.dc_hia)	
	left outer join caixa_hou_imp_aer as MasOposC on ( masopos.num_proc_hia=masoposc.num_proc_hia and masopos.cd_tp_Tx=masoposc.cd_tp_tx and masopos.dc_hia=masoposc.dc_hia and masoposc.num_lcto <> 'PROVISÓRIO' and convert(datetime, masoposc.dt_pgto_rcto_hia, 105) <= convert(datetime, @Datafinal, 105)) 
where

	cxa.Vlr_ref_mia is null  AND
	(opos.vlr_ref_mia is not null or masoposc.vlr_ref_hia is not null)
	AND CONVERT(DATETIME, CTA.DT_INS_mia, 105) between
	convert(datetime, @DataInicial, 105) and
	convert(datetime, @DataFinal, 105)
	and cta.desp_org_mia='N'
group by 

	Cta.NUM_PROC_mia, nome_tp_Tx, Cta.DC_mia, cta.vlr_org_mia, oPOS.Vlr_Ref_mia, opos.dt_pgto_rcto_mia, apelido
	, OPOS.par_moeda_mia, oposc.cd_tp_moeda, cta.cd_tp_moeda , masopos.cd_tp_moeda , masoposc.par_moeda_hia, masoposc.dt_pgto_rcto_hia 





GO
