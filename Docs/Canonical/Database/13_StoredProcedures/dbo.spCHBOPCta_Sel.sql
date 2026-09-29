SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE   Procedure [dbo].[spCHBOPCta_Sel]
(
		@Num_Proc	Varchar(16),
		@Apelido	Varchar(50),
		@DT_PAR  	CHAR(10)
)
AS


		select 
			Apelido nome_raz_soc, nome_tp_tx,cta.dc_him DC, 
			vlr_org_him Vlr_Org, cxa.vlr_pgto_rcto_hia Vlr_PG,cta.cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'IMM'),1) Paridade,CTA.CD_TP_TX,cta.num_proc_him Processo
		from 
			cta_cte_hou_imp_mar CTA
			Join House_Imp_mar HOU on HOU.num_proc_him=CTA.num_proc_him and CTa.cd_cred_deV_him=hOU.cd_consig_him
			join pessoa pp on pp.cd_pes=cta.cd_cred_dev_him
			join tipo_taxa tt on tt.cd_tp_tx=cta.cd_tp_tx
			left Join vwCXAS cxa on cta.num_proc_him=cxa.num_proc_hia and cta.cd_Tp_tx=cxa.cd_tp_tx and cta.dc_him=cxa.dc_hia and num_lcto <> 'PROVISÓRIO'
			--left join paridade par on par.cd_tp_moeda=cta.cd_tp_moeda and PAR.cd_tp_par='IMM' AND CONVERT(datetime,DT_PAR,105)=@Dt_Par
		WHERE 
			cta.num_proc_him=@num_proc AND DESP_ORG_HIM='N'


union

		select 
			Apelido nome_raz_soc, nome_tp_tx,cta.dc_hia DC, 
			vlr_org_hia Vlr_Org, cxa.vlr_pgto_rcto_hia Vlr_PG,cta.cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'IMA'),1) Paridade,CTA.CD_TP_TX,cta.num_proc_hia Processo
		from 
			cta_cte_hou_imp_aer CTA
			Join House_Imp_aer HOU on HOU.num_proc_hia=CTA.num_proc_hia and CTa.cd_cred_deV_hia=hOU.cd_consig_hia
			join pessoa pp on pp.cd_pes=cta.cd_cred_dev_hia
			join tipo_taxa tt on tt.cd_tp_tx=cta.cd_tp_tx
			left Join vwCXAS cxa on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_Tp_tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia and num_lcto <> 'PROVISÓRIO'
			--left join paridade par on par.cd_tp_moeda=cta.cd_tp_moeda and PAR.cd_tp_par='IMM' AND CONVERT(datetime,DT_PAR,105)=@Dt_Par
		WHERE 
			cta.num_proc_hia=@num_proc AND DESP_ORG_HIA='N'

union

		select 
			Apelido nome_raz_soc, nome_tp_tx,cta.dc_hio DC, 
			vlr_org_hio Vlr_Org, cxa.vlr_pgto_rcto_hia Vlr_PG,cta.cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,CTA.CD_TP_TX,cta.num_proc_hio Processo
		from 
			cta_cte_hou_imp_out CTA
			Join House_Imp_out HOU on HOU.num_proc_hio=CTA.num_proc_hio and CTa.cd_cred_deV_hio=hOU.cd_consig_hio
			join pessoa pp on pp.cd_pes=cta.cd_cred_dev_hio
			join tipo_taxa tt on tt.cd_tp_tx=cta.cd_tp_tx
			left Join vwCXAS cxa on cta.num_proc_hio=cxa.num_proc_hia and cta.cd_Tp_tx=cxa.cd_tp_tx and cta.dc_hio=cxa.dc_hia and num_lcto <> 'PROVISÓRIO'
			--left join paridade par on par.cd_tp_moeda=cta.cd_tp_moeda and PAR.cd_tp_par='IMM' AND CONVERT(datetime,DT_PAR,105)=@Dt_Par
		WHERE 
			cta.num_proc_hio=@num_proc AND DESP_ORG_HIO='N'
UNION


		select 
			Apelido nome_raz_soc, nome_tp_tx,cta.dc_HEM DC, 
			vlr_org_HEM Vlr_Org, cxa.vlr_pgto_rcto_hia Vlr_PG,cta.cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'EXM'),1) Paridade,CTA.CD_TP_TX,cta.num_proc_HEM Processo
		from 
			cta_cte_hou_EXP_mar CTA
			Join House_EXP_mar HOU on HOU.num_proc_HEM=CTA.num_proc_HEM and CTa.cd_cred_deV_HEM=hOU.cd_export_HEM
			join pessoa pp on pp.cd_pes=cta.cd_cred_dev_HEM
			join tipo_taxa tt on tt.cd_tp_tx=cta.cd_tp_tx
			left Join vwCXAS cxa on cta.num_proc_HEM=cxa.num_proc_hia and cta.cd_Tp_tx=cxa.cd_tp_tx and cta.dc_HEM=cxa.dc_hia and num_lcto <> 'PROVISÓRIO'
			--left join paridade par on par.cd_tp_moeda=cta.cd_tp_moeda and PAR.cd_tp_par='IMM' AND CONVERT(datetime,DT_PAR,105)=@Dt_Par
		WHERE 
			cta.num_proc_HEM=@num_proc AND DESP_DST_HEM='N'


union

		select 
			Apelido nome_raz_soc, nome_tp_tx,cta.dc_HEA DC, 
			vlr_org_HEA Vlr_Org, cxa.vlr_pgto_rcto_hia Vlr_PG,cta.cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'EXA'),1) Paridade,CTA.CD_TP_TX,cta.num_proc_HEA Processo
		from 
			cta_cte_hou_EXP_aer CTA
			Join House_EXP_aer HOU on HOU.num_proc_HEA=CTA.num_proc_HEA and CTa.cd_cred_deV_HEA=hOU.cd_export_HEA
			join pessoa pp on pp.cd_pes=cta.cd_cred_dev_HEA
			join tipo_taxa tt on tt.cd_tp_tx=cta.cd_tp_tx
			left Join vwCXAS cxa on cta.num_proc_HEA=cxa.num_proc_hia and cta.cd_Tp_tx=cxa.cd_tp_tx and cta.dc_HEA=cxa.dc_hia and num_lcto <> 'PROVISÓRIO'
			--left join paridade par on par.cd_tp_moeda=cta.cd_tp_moeda and PAR.cd_tp_par='IMM' AND CONVERT(datetime,DT_PAR,105)=@Dt_Par
		WHERE 
			cta.num_proc_HEA=@num_proc AND DESP_DST_HEA='N'

union

		select 
			Apelido nome_raz_soc, nome_tp_tx,cta.dc_HEO DC, 
			vlr_org_HEO Vlr_Org, cxa.vlr_pgto_rcto_hia Vlr_PG,cta.cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,CTA.CD_TP_TX,cta.num_proc_HEO Processo
		from 
			cta_cte_hou_EXP_out CTA
			Join House_EXP_out HOU on HOU.num_proc_HEO=CTA.num_proc_HEO and CTa.cd_cred_deV_HEO=hOU.cd_export_HEO
			join pessoa pp on pp.cd_pes=cta.cd_cred_dev_HEO
			join tipo_taxa tt on tt.cd_tp_tx=cta.cd_tp_tx
			left Join vwCXAS cxa on cta.num_proc_HEO=cxa.num_proc_hia and cta.cd_Tp_tx=cxa.cd_tp_tx and cta.dc_HEO=cxa.dc_hia and num_lcto <> 'PROVISÓRIO'
			--left join paridade par on par.cd_tp_moeda=cta.cd_tp_moeda and PAR.cd_tp_par='IMM' AND CONVERT(datetime,DT_PAR,105)=@Dt_Par
		WHERE 
			cta.num_proc_HEO=@num_proc AND DESP_ORG_HEO='N'
union
		
		select 
			Apelido nome_raz_soc, nome_tp_tx,cta.dc_MIA DC, 
			vlr_org_MIA Vlr_Org, cxa.vlr_pgto_rcto_hia Vlr_PG,cta.cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'IMA'),1) Paridade,CTA.CD_TP_TX,cta.num_proc_MIA Processo
		from 
			cta_cte_MAS_IMP_aer CTA
			Join Master_IMP_aer MAS on MAS.num_proc_MIA=CTA.num_proc_MIA and CTa.cd_cred_deV_MIA=MAS.cd_consig_MIA
			join pessoa pp on pp.cd_pes=cta.cd_cred_dev_MIA
			join tipo_taxa tt on tt.cd_tp_tx=cta.cd_tp_tx
			left Join vwCXAS cxa on cta.num_proc_MIA=cxa.num_proc_HIA and cta.cd_Tp_tx=cxa.cd_tp_tx and cta.dc_MIA=cxa.dc_HIA and num_lcto <> 'PROVISÓRIO'
			--left join paridade par on par.cd_tp_moeda=cta.cd_tp_moeda and PAR.cd_tp_par='IMM' AND CONVERT(datetime,DT_PAR,105)=@Dt_Par
		WHERE 
			cta.num_proc_MIA=@num_proc AND DESP_ORG_MIA='N' and right(left(cta.num_proc_mia,5),3) = 'CLI'
union
	
	select 
			Apelido nome_raz_soc, nome_tp_tx,cta.dc_mim DC, 
			vlr_org_mim Vlr_Org, cxa.vlr_pgto_rcto_hia Vlr_PG,cta.cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'IMM'),1) Paridade,CTA.CD_TP_TX,cta.num_proc_mim Processo
		from 
			cta_cte_MAS_IMP_mar CTA
			Join Master_IMP_mar MAS on MAS.num_proc_mim=CTA.num_proc_mim and CTa.cd_cred_deV_mim=MAS.cd_consig_mim
			join pessoa pp on pp.cd_pes=cta.cd_cred_dev_mim
			join tipo_taxa tt on tt.cd_tp_tx=cta.cd_tp_tx
			left Join vwCXAS cxa on cta.num_proc_mim=cxa.num_proc_hia and cta.cd_Tp_tx=cxa.cd_tp_tx and cta.dc_mim=cxa.dc_Hia and num_lcto <> 'PROVISÓRIO'
			--left join paridade par on par.cd_tp_moeda=cta.cd_tp_moeda and PAR.cd_tp_par='IMM' AND CONVERT(datetime,DT_PAR,105)=@Dt_Par
		WHERE 
			cta.num_proc_mim=@num_proc AND DESP_ORG_mim='N' and right(left(cta.num_proc_mim,5),3) = 'CLI'

union

	select 
			Apelido nome_raz_soc, nome_tp_tx,cta.dc_mea DC, 
			vlr_org_mea Vlr_Org, cxa.vlr_pgto_rcto_hia Vlr_PG,cta.cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'EXA'),1) Paridade,CTA.CD_TP_TX,cta.num_proc_mea Processo
		from 
			cta_cte_MAS_exp_aer CTA
			Join Master_exp_aer MAS on MAS.num_proc_mea=CTA.num_proc_mea and CTa.cd_cred_deV_mea=MAS.cd_export_mea
			join pessoa pp on pp.cd_pes=cta.cd_cred_dev_mea
			join tipo_taxa tt on tt.cd_tp_tx=cta.cd_tp_tx
			left Join vwCXAS cxa on cta.num_proc_mea=cxa.num_proc_hia and cta.cd_Tp_tx=cxa.cd_tp_tx and cta.dc_mea=cxa.dc_hia and num_lcto <> 'PROVISÓRIO'
			--left join paridade par on par.cd_tp_moeda=cta.cd_tp_moeda and PAR.cd_tp_par='IMM' AND CONVERT(datetime,DT_PAR,105)=@Dt_Par
		WHERE 
			cta.num_proc_mea=@num_proc AND DESP_DST_mea='N' and right(left(cta.num_proc_mea,5),3) = 'CLI'

union

	select 
			Apelido nome_raz_soc, nome_tp_tx,cta.dc_mem DC, 
			vlr_org_mem Vlr_Org, cxa.vlr_pgto_rcto_hia Vlr_PG,cta.cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'EXM'),1) Paridade,CTA.CD_TP_TX,cta.num_proc_mem Processo
		from 
			cta_cte_MAS_exp_mar CTA
			Join Master_exp_mar MAS on MAS.num_proc_mem=CTA.num_proc_mem and CTa.cd_cred_deV_mem=MAS.cd_export_mem
			join pessoa pp on pp.cd_pes=cta.cd_cred_dev_mem
			join tipo_taxa tt on tt.cd_tp_tx=cta.cd_tp_tx
			left Join vwCXAS cxa on cta.num_proc_mem=cxa.num_proc_hia and cta.cd_Tp_tx=cxa.cd_tp_tx and cta.dc_mem=cxa.dc_hia and num_lcto <> 'PROVISÓRIO'
			--left join paridade par on par.cd_tp_moeda=cta.cd_tp_moeda and PAR.cd_tp_par='IMM' AND CONVERT(datetime,DT_PAR,105)=@Dt_Par
		WHERE 
			cta.num_proc_mem=@num_proc AND DESP_DST_mem='N' and right(left(cta.num_proc_mem,5),3) = 'CLI'
/*
		select 
			Apelido nome_raz_soc, nome_tp_tx,cta.dc_him DC, 
			vlr_org_him Vlr_Org, vlr_pgto_rcto_him Vlr_PG,cta.cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'IMM'),1) Paridade,CTA.CD_TP_TX,cta.num_proc_him Processo
		from 
			cta_cte_hou_imp_mar CTA
			Join House_Imp_mar HOU on HOU.num_proc_him=CTA.num_proc_him and CTa.cd_cred_deV_him=hOU.cd_consig_him
			join pessoa pp on pp.cd_pes=cta.cd_cred_dev_him
			join tipo_taxa tt on tt.cd_tp_tx=cta.cd_tp_tx
			left Join Caixa_hou_imp_mar cxa on cta.num_proc_him=cxa.num_proc_him and cta.cd_Tp_tx=cxa.cd_tp_tx and cta.dc_him=cxa.dc_him and num_lcto <> 'PROVISÓRIO'
			--left join paridade par on par.cd_tp_moeda=cta.cd_tp_moeda and PAR.cd_tp_par='IMM' AND CONVERT(datetime,DT_PAR,105)=@Dt_Par
		WHERE 
			cta.num_proc_him=@num_proc AND DESP_ORG_HIM='N'


union

		select 
			Apelido nome_raz_soc, nome_tp_tx,cta.dc_hia DC, 
			vlr_org_hia Vlr_Org, vlr_pgto_rcto_hia Vlr_PG,cta.cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'IMA'),1) Paridade,CTA.CD_TP_TX,cta.num_proc_hia Processo
		from 
			cta_cte_hou_imp_aer CTA
			Join House_Imp_aer HOU on HOU.num_proc_hia=CTA.num_proc_hia and CTa.cd_cred_deV_hia=hOU.cd_consig_hia
			join pessoa pp on pp.cd_pes=cta.cd_cred_dev_hia
			join tipo_taxa tt on tt.cd_tp_tx=cta.cd_tp_tx
			left Join Caixa_hou_imp_aer cxa on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_Tp_tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia and num_lcto <> 'PROVISÓRIO'
			--left join paridade par on par.cd_tp_moeda=cta.cd_tp_moeda and PAR.cd_tp_par='IMM' AND CONVERT(datetime,DT_PAR,105)=@Dt_Par
		WHERE 
			cta.num_proc_hia=@num_proc AND DESP_ORG_HIA='N'

union

		select 
			Apelido nome_raz_soc, nome_tp_tx,cta.dc_hio DC, 
			vlr_org_hio Vlr_Org, vlr_pgto_rcto_hio Vlr_PG,cta.cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,CTA.CD_TP_TX,cta.num_proc_hio Processo
		from 
			cta_cte_hou_imp_out CTA
			Join House_Imp_out HOU on HOU.num_proc_hio=CTA.num_proc_hio and CTa.cd_cred_deV_hio=hOU.cd_consig_hio
			join pessoa pp on pp.cd_pes=cta.cd_cred_dev_hio
			join tipo_taxa tt on tt.cd_tp_tx=cta.cd_tp_tx
			left Join Caixa_hou_imp_out cxa on cta.num_proc_hio=cxa.num_proc_hio and cta.cd_Tp_tx=cxa.cd_tp_tx and cta.dc_hio=cxa.dc_hio and num_lcto <> 'PROVISÓRIO'
			--left join paridade par on par.cd_tp_moeda=cta.cd_tp_moeda and PAR.cd_tp_par='IMM' AND CONVERT(datetime,DT_PAR,105)=@Dt_Par
		WHERE 
			cta.num_proc_hio=@num_proc AND DESP_ORG_HIO='N'
UNION


		select 
			Apelido nome_raz_soc, nome_tp_tx,cta.dc_HEM DC, 
			vlr_org_HEM Vlr_Org, vlr_pgto_rcto_HEM Vlr_PG,cta.cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'EXM'),1) Paridade,CTA.CD_TP_TX,cta.num_proc_HEM Processo
		from 
			cta_cte_hou_EXP_mar CTA
			Join House_EXP_mar HOU on HOU.num_proc_HEM=CTA.num_proc_HEM and CTa.cd_cred_deV_HEM=hOU.cd_export_HEM
			join pessoa pp on pp.cd_pes=cta.cd_cred_dev_HEM
			join tipo_taxa tt on tt.cd_tp_tx=cta.cd_tp_tx
			left Join Caixa_hou_EXP_mar cxa on cta.num_proc_HEM=cxa.num_proc_HEM and cta.cd_Tp_tx=cxa.cd_tp_tx and cta.dc_HEM=cxa.dc_HEM and num_lcto <> 'PROVISÓRIO'
			--left join paridade par on par.cd_tp_moeda=cta.cd_tp_moeda and PAR.cd_tp_par='IMM' AND CONVERT(datetime,DT_PAR,105)=@Dt_Par
		WHERE 
			cta.num_proc_HEM=@num_proc AND DESP_DST_HEM='N'


union

		select 
			Apelido nome_raz_soc, nome_tp_tx,cta.dc_HEA DC, 
			vlr_org_HEA Vlr_Org, vlr_pgto_rcto_HEA Vlr_PG,cta.cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'EXA'),1) Paridade,CTA.CD_TP_TX,cta.num_proc_HEA Processo
		from 
			cta_cte_hou_EXP_aer CTA
			Join House_EXP_aer HOU on HOU.num_proc_HEA=CTA.num_proc_HEA and CTa.cd_cred_deV_HEA=hOU.cd_export_HEA
			join pessoa pp on pp.cd_pes=cta.cd_cred_dev_HEA
			join tipo_taxa tt on tt.cd_tp_tx=cta.cd_tp_tx
			left Join Caixa_hou_EXP_aer cxa on cta.num_proc_HEA=cxa.num_proc_HEA and cta.cd_Tp_tx=cxa.cd_tp_tx and cta.dc_HEA=cxa.dc_HEA and num_lcto <> 'PROVISÓRIO'
			--left join paridade par on par.cd_tp_moeda=cta.cd_tp_moeda and PAR.cd_tp_par='IMM' AND CONVERT(datetime,DT_PAR,105)=@Dt_Par
		WHERE 
			cta.num_proc_HEA=@num_proc AND DESP_DST_HEA='N'

union

		select 
			Apelido nome_raz_soc, nome_tp_tx,cta.dc_HEO DC, 
			vlr_org_HEO Vlr_Org, vlr_pgto_rcto_HEO Vlr_PG,cta.cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,CTA.CD_TP_TX,cta.num_proc_HEO Processo
		from 
			cta_cte_hou_EXP_out CTA
			Join House_EXP_out HOU on HOU.num_proc_HEO=CTA.num_proc_HEO and CTa.cd_cred_deV_HEO=hOU.cd_export_HEO
			join pessoa pp on pp.cd_pes=cta.cd_cred_dev_HEO
			join tipo_taxa tt on tt.cd_tp_tx=cta.cd_tp_tx
			left Join Caixa_hou_EXP_out cxa on cta.num_proc_HEO=cxa.num_proc_HEO and cta.cd_Tp_tx=cxa.cd_tp_tx and cta.dc_HEO=cxa.dc_HEO and num_lcto <> 'PROVISÓRIO'
			--left join paridade par on par.cd_tp_moeda=cta.cd_tp_moeda and PAR.cd_tp_par='IMM' AND CONVERT(datetime,DT_PAR,105)=@Dt_Par
		WHERE 
			cta.num_proc_HEO=@num_proc AND DESP_ORG_HEO='N'
union
		
		select 
			Apelido nome_raz_soc, nome_tp_tx,cta.dc_MIA DC, 
			vlr_org_MIA Vlr_Org, vlr_pgto_rcto_MIA Vlr_PG,cta.cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'IMA'),1) Paridade,CTA.CD_TP_TX,cta.num_proc_MIA Processo
		from 
			cta_cte_MAS_IMP_aer CTA
			Join Master_IMP_aer MAS on MAS.num_proc_MIA=CTA.num_proc_MIA and CTa.cd_cred_deV_MIA=MAS.cd_consig_MIA
			join pessoa pp on pp.cd_pes=cta.cd_cred_dev_MIA
			join tipo_taxa tt on tt.cd_tp_tx=cta.cd_tp_tx
			left Join Caixa_MAS_IMP_aer cxa on cta.num_proc_MIA=cxa.num_proc_MIA and cta.cd_Tp_tx=cxa.cd_tp_tx and cta.dc_MIA=cxa.dc_MIA and num_lcto <> 'PROVISÓRIO'
			--left join paridade par on par.cd_tp_moeda=cta.cd_tp_moeda and PAR.cd_tp_par='IMM' AND CONVERT(datetime,DT_PAR,105)=@Dt_Par
		WHERE 
			cta.num_proc_MIA=@num_proc AND DESP_ORG_MIA='N' and right(left(cta.num_proc_mia,5),3) = 'CLI'
union
	
	select 
			Apelido nome_raz_soc, nome_tp_tx,cta.dc_mim DC, 
			vlr_org_mim Vlr_Org, vlr_pgto_rcto_mim Vlr_PG,cta.cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'IMM'),1) Paridade,CTA.CD_TP_TX,cta.num_proc_mim Processo
		from 
			cta_cte_MAS_IMP_mar CTA
			Join Master_IMP_mar MAS on MAS.num_proc_mim=CTA.num_proc_mim and CTa.cd_cred_deV_mim=MAS.cd_consig_mim
			join pessoa pp on pp.cd_pes=cta.cd_cred_dev_mim
			join tipo_taxa tt on tt.cd_tp_tx=cta.cd_tp_tx
			left Join Caixa_MAS_IMP_mar cxa on cta.num_proc_mim=cxa.num_proc_mim and cta.cd_Tp_tx=cxa.cd_tp_tx and cta.dc_mim=cxa.dc_mim and num_lcto <> 'PROVISÓRIO'
			--left join paridade par on par.cd_tp_moeda=cta.cd_tp_moeda and PAR.cd_tp_par='IMM' AND CONVERT(datetime,DT_PAR,105)=@Dt_Par
		WHERE 
			cta.num_proc_mim=@num_proc AND DESP_ORG_mim='N' and right(left(cta.num_proc_mim,5),3) = 'CLI'

union

	select 
			Apelido nome_raz_soc, nome_tp_tx,cta.dc_mea DC, 
			vlr_org_mea Vlr_Org, vlr_pgto_rcto_mea Vlr_PG,cta.cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'EXA'),1) Paridade,CTA.CD_TP_TX,cta.num_proc_mea Processo
		from 
			cta_cte_MAS_exp_aer CTA
			Join Master_exp_aer MAS on MAS.num_proc_mea=CTA.num_proc_mea and CTa.cd_cred_deV_mea=MAS.cd_export_mea
			join pessoa pp on pp.cd_pes=cta.cd_cred_dev_mea
			join tipo_taxa tt on tt.cd_tp_tx=cta.cd_tp_tx
			left Join Caixa_MAS_exp_aer cxa on cta.num_proc_mea=cxa.num_proc_mea and cta.cd_Tp_tx=cxa.cd_tp_tx and cta.dc_mea=cxa.dc_mea and num_lcto <> 'PROVISÓRIO'
			--left join paridade par on par.cd_tp_moeda=cta.cd_tp_moeda and PAR.cd_tp_par='IMM' AND CONVERT(datetime,DT_PAR,105)=@Dt_Par
		WHERE 
			cta.num_proc_mea=@num_proc AND DESP_DST_mea='N' and right(left(cta.num_proc_mea,5),3) = 'CLI'

union

	select 
			Apelido nome_raz_soc, nome_tp_tx,cta.dc_mem DC, 
			vlr_org_mem Vlr_Org, vlr_pgto_rcto_mem Vlr_PG,cta.cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'EXM'),1) Paridade,CTA.CD_TP_TX,cta.num_proc_mem Processo
		from 
			cta_cte_MAS_exp_mar CTA
			Join Master_exp_mar MAS on MAS.num_proc_mem=CTA.num_proc_mem and CTa.cd_cred_deV_mem=MAS.cd_export_mem
			join pessoa pp on pp.cd_pes=cta.cd_cred_dev_mem
			join tipo_taxa tt on tt.cd_tp_tx=cta.cd_tp_tx
			left Join Caixa_MAS_exp_mar cxa on cta.num_proc_mem=cxa.num_proc_mem and cta.cd_Tp_tx=cxa.cd_tp_tx and cta.dc_mem=cxa.dc_mem and num_lcto <> 'PROVISÓRIO'
			--left join paridade par on par.cd_tp_moeda=cta.cd_tp_moeda and PAR.cd_tp_par='IMM' AND CONVERT(datetime,DT_PAR,105)=@Dt_Par
		WHERE 
			cta.num_proc_mem=@num_proc AND DESP_DST_mem='N' and right(left(cta.num_proc_mem,5),3) = 'CLI'
*/
GO
