SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [dbo].[pAeKContCtaCte2_Sel] 
(
@Ano		VarChar(4),
@Mes 		Char(2)
)
AS
	Select 
		Cte.cd_tp_moeda, dt_ins_him dt_ins, cte.num_proc_him num_proc, cte.dc_him dc, (case when cte.cd_tp_moeda = 'REL' then 1 else par_moeda end) par_moeda , 
		taxa_ofc.cd_tp_tx, taxa_ofc.cd_tp_tx cd_tp_tx, taxa_ofc.nome_tp_tx desc_taxa, vlr_org_him vlr_org, cxa.vlr_pgto_rcto_him vlr_pgto, 
		pes.nome_raz_soc cred_dev, dt_pgto_rcto_him dt_pgto, Vlr_Contab Vlr_DS4
	from 	
		Cta_Cte_Hou_Imp_Mar cte Join tipo_taxa taxa_ofc on taxa_ofc.cd_tp_tx = cte.cd_tp_tx 
		left join paridade par on par.cd_tp_moeda = cte.cd_tp_moeda and par.cd_tp_par = 'IMM' and par.dt_par = cte.dt_ins_him 
		left join Caixa_Hou_Imp_Mar Cxa on Cxa.Num_Proc_HIM = Cte.Num_Proc_HIM and Cxa.DC_HIM = Cte.DC_HIM and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx AND CXA.NUM_LCTO <> 'PROVISÓRIO'  and month(convert(datetime, cxa.dt_pgto_rcto_him, 105)) = @Mes and year(convert(datetime, cxa.dt_pgto_rcto_him, 105)) = @Ano 
		join pessoa pes on pes.cd_pes = cte.cd_cred_dev_him 
	Where 
		DESP_ORG_HIM = 'N' and Cte.Cd_Tp_Tx not in (Select Cd_Tp_Tx From Param_AekContabil_Taxas_Exc) and 
		month(convert(datetime, cte.dt_ins_him, 105)) = @Mes and year(convert(datetime, cte.dt_ins_him, 105)) = @Ano and 
		left(cte.num_proc_him, 5) <> 'IMJOB' and left(cte.cd_tp_tx, 1) <> 'X' and Val_Con_Comp is null

	Union 

	Select 
		Cte.cd_tp_moeda, dt_ins_HIA dt_ins, cte.num_proc_HIA num_proc, cte.dc_HIA dc, (case when cte.cd_tp_moeda = 'REL' then 1 else par_moeda end) par_moeda , 
		taxa_ofc.cd_tp_tx, taxa_ofc.cd_tp_tx cd_tp_tx, taxa_ofc.nome_tp_tx desc_taxa, vlr_org_HIA vlr_org , cxa.vlr_pgto_rcto_hia vlr_pgto, 
		pes.nome_raz_soc cred_dev, dt_pgto_rcto_hia dt_pgto, Vlr_Contab Vlr_DS4
	from 	
		Cta_Cte_Hou_Imp_Aer cte Join tipo_taxa taxa_ofc on taxa_ofc.cd_tp_tx = cte.cd_tp_tx 
		left join paridade par on par.cd_tp_moeda = cte.cd_tp_moeda and par.cd_tp_par = 'IMA' and par.dt_par = cte.dt_ins_HIA 
		left join Caixa_Hou_Imp_Aer Cxa on Cxa.Num_Proc_HIA = Cte.Num_Proc_HIA and Cxa.DC_HIA = Cte.DC_HIA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx AND CXA.NUM_LCTO <> 'PROVISÓRIO'  and month(convert(datetime, cxa.dt_pgto_rcto_hia, 105)) = @Mes and year(convert(datetime, cxa.dt_pgto_rcto_hia, 105)) = @Ano 
		join pessoa pes on pes.cd_pes = cte.cd_cred_dev_hia 
	Where 
		DESP_ORG_HIA = 'N' and Cte.Cd_Tp_Tx not in (Select Cd_Tp_Tx From Param_AekContabil_Taxas_Exc) and 
		month(convert(datetime, cte.dt_ins_HIA, 105)) = @Mes and year(convert(datetime, cte.dt_ins_HIA, 105)) = @Ano and 
		left(cte.num_proc_HIA, 5) <> 'IAJOB' and left(cte.cd_tp_tx, 1) <> 'X' and Val_Con_Comp is null


	Union 

	Select 
		Cte.cd_tp_moeda, dt_ins_HIO dt_ins, cte.num_proc_HIO num_proc, cte.dc_HIO dc, (case when cte.cd_tp_moeda = 'REL' then 1 else par_moeda end) par_moeda , 
		taxa_ofc.cd_tp_tx, taxa_ofc.cd_tp_tx cd_tp_tx, taxa_ofc.nome_tp_tx desc_taxa, vlr_org_HIO vlr_org , cxa.vlr_pgto_rcto_HIO vlr_pgto, 
		pes.nome_raz_soc cred_dev, dt_pgto_rcto_HIO dt_pgto, Vlr_Contab Vlr_DS4
	from 	
		Cta_Cte_Hou_Imp_Out cte Join tipo_taxa taxa_ofc on taxa_ofc.cd_tp_tx = cte.cd_tp_tx 
		left join paridade par on par.cd_tp_moeda = cte.cd_tp_moeda and par.cd_tp_par = 'IMA' and par.dt_par = cte.dt_ins_HIO 
		left join Caixa_Hou_Imp_Out Cxa on Cxa.Num_Proc_HIO = Cte.Num_Proc_HIO and Cxa.DC_HIO = Cte.DC_HIO and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx AND CXA.NUM_LCTO <> 'PROVISÓRIO'  and month(convert(datetime, cxa.dt_pgto_rcto_HIO, 105)) = @Mes and year(convert(datetime, cxa.dt_pgto_rcto_HIO, 105)) = @Ano 
		join pessoa pes on pes.cd_pes = cte.cd_cred_dev_HIO 
	Where 
		DESP_ORG_HIO = 'N' and Cte.Cd_Tp_Tx not in (Select Cd_Tp_Tx From Param_AekContabil_Taxas_Exc) and 
		month(convert(datetime, cte.dt_ins_HIO, 105)) = @Mes and year(convert(datetime, cte.dt_ins_HIO, 105)) = @Ano and 
		left(cte.cd_tp_tx, 1) <> 'X'	and Val_Con_Comp is null


	Union 

	Select 
		Cte.cd_tp_moeda, dt_ins_HEM dt_ins, cte.num_proc_HEM num_proc, cte.dc_HEM dc, (case when cte.cd_tp_moeda = 'REL' then 1 else par_moeda end) par_moeda , 
		taxa_ofc.cd_tp_tx, taxa_ofc.cd_tp_tx cd_tp_tx, taxa_ofc.nome_tp_tx desc_taxa, vlr_org_HEM vlr_org, cxa.vlr_pgto_rcto_HEM vlr_pgto, 
		pes.nome_raz_soc cred_dev, dt_pgto_rcto_hem dt_pgto, Vlr_Contab Vlr_DS4
	from 	
		Cta_Cte_Hou_Exp_Mar cte Join tipo_taxa taxa_ofc on taxa_ofc.cd_tp_tx = cte.cd_tp_tx 
		left join paridade par on par.cd_tp_moeda = cte.cd_tp_moeda and par.cd_tp_par = 'EXM' and par.dt_par = cte.dt_ins_HEM 
		left join Caixa_Hou_Exp_Mar Cxa on Cxa.Num_Proc_HEM = Cte.Num_Proc_HEM and Cxa.DC_HEM = Cte.DC_HEM and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx AND CXA.NUM_LCTO <> 'PROVISÓRIO'  and month(convert(datetime, cxa.dt_pgto_rcto_hem, 105)) = @Mes and year(convert(datetime, cxa.dt_pgto_rcto_hem, 105)) = @Ano 
		join pessoa pes on pes.cd_pes = cte.cd_cred_dev_hem 
	Where 
		DESP_DST_HEM = 'N' and Cte.Cd_Tp_Tx not in (Select Cd_Tp_Tx From Param_AekContabil_Taxas_Exc) and 
		month(convert(datetime, cte.dt_ins_HEM, 105)) = @Mes and year(convert(datetime, cte.dt_ins_HEM, 105)) = @Ano and 
		left(cte.num_proc_HEM, 5) <> 'EMJOB' and left(cte.cd_tp_tx, 1) <> 'X' and Val_Con_Comp is null

	Union 

	Select 
		Cte.cd_tp_moeda, dt_ins_HEA dt_ins, cte.num_proc_HEA num_proc, cte.dc_HEA dc, (case when cte.cd_tp_moeda = 'REL' then 1 else par_moeda end) par_moeda , 
		taxa_ofc.cd_tp_tx, taxa_ofc.cd_tp_tx cd_tp_tx, taxa_ofc.nome_tp_tx desc_taxa, vlr_org_HEA vlr_org, cxa.vlr_pgto_rcto_HEA vlr_pgto, 
		pes.nome_raz_soc cred_dev, dt_pgto_rcto_hea dt_pgto, Vlr_Contab Vlr_DS4
	from 	
		Cta_Cte_Hou_Exp_Aer cte Join tipo_taxa taxa_ofc on taxa_ofc.cd_tp_tx = cte.cd_tp_tx 
		left join paridade par on par.cd_tp_moeda = cte.cd_tp_moeda and par.cd_tp_par = 'EXA' and par.dt_par = cte.dt_ins_HEA 
		left join Caixa_Hou_Exp_Aer Cxa on Cxa.Num_Proc_HEA = Cte.Num_Proc_HEA and Cxa.DC_HEA = Cte.DC_HEA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx AND CXA.NUM_LCTO <> 'PROVISÓRIO'  and month(convert(datetime, cxa.dt_pgto_rcto_hea, 105)) = @Mes and year(convert(datetime, cxa.dt_pgto_rcto_hea, 105)) = @Ano 
		join pessoa pes on pes.cd_pes = cte.cd_cred_dev_hea 
	Where 
		DESP_DST_HEA = 'N' and Cte.Cd_Tp_Tx not in (Select Cd_Tp_Tx From Param_AekContabil_Taxas_Exc) and 
		month(convert(datetime, cte.dt_ins_HEA, 105)) = @Mes and year(convert(datetime, cte.dt_ins_HEA, 105)) = @Ano and 
		left(cte.num_proc_HEA, 5) <> 'EAJOB' and left(cte.cd_tp_tx, 1) <> 'X' and Val_Con_Comp is null

	Union 


	Select 
		Cte.cd_tp_moeda, dt_ins_HEO dt_ins, cte.num_proc_HEO num_proc, cte.dc_HEO dc, (case when cte.cd_tp_moeda = 'REL' then 1 else par_moeda end) par_moeda , 
		taxa_ofc.cd_tp_tx, taxa_ofc.cd_tp_tx cd_tp_tx, taxa_ofc.nome_tp_tx desc_taxa, vlr_org_HEO vlr_org, cxa.vlr_pgto_rcto_HEO vlr_pgto, 
		pes.nome_raz_soc cred_dev, dt_pgto_rcto_heo dt_pgto, Vlr_Contab Vlr_DS4
	from 	
		Cta_Cte_Hou_Exp_Out cte Join tipo_taxa taxa_ofc on taxa_ofc.cd_tp_tx = cte.cd_tp_tx 
		left join paridade par on par.cd_tp_moeda = cte.cd_tp_moeda and par.cd_tp_par = 'IMA' and par.dt_par = cte.dt_ins_HEO
		left join Caixa_Hou_Exp_Out Cxa on Cxa.Num_Proc_HEO = Cte.Num_Proc_HEO and Cxa.DC_HEO = Cte.DC_HEO and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx AND CXA.NUM_LCTO <> 'PROVISÓRIO'  and month(convert(datetime, cxa.dt_pgto_rcto_heo, 105)) = @Mes and year(convert(datetime, cxa.dt_pgto_rcto_heo, 105)) = @Ano 
		join pessoa pes on pes.cd_pes = cte.cd_cred_dev_heO
	Where 
		DESP_ORG_HEO = 'N' and Cte.Cd_Tp_Tx not in (Select Cd_Tp_Tx From Param_AekContabil_Taxas_Exc) and 
		month(convert(datetime, cte.dt_ins_HEO, 105)) = @Mes and year(convert(datetime, cte.dt_ins_HEO, 105)) = @Ano and 
		left(cte.cd_tp_tx, 1) <> 'X' and Val_Con_Comp is null

	Union 

	Select 
		Cte.cd_tp_moeda, dt_ins_MIM dt_ins, cte.num_proc_MIM num_proc, cte.dc_MIM dc, (case when cte.cd_tp_moeda = 'REL' then 1 else par_moeda end) par_moeda , 
		taxa_ofc.cd_tp_tx, taxa_ofc.cd_tp_tx cd_tp_tx, taxa_ofc.nome_tp_tx desc_taxa, vlr_org_MIM vlr_org, cxa.vlr_pgto_rcto_MIM vlr_pgto, 
		pes.nome_raz_soc cred_dev, dt_pgto_rcto_mim dt_pgto, Vlr_Contab Vlr_DS4
	from 	
		Cta_Cte_Mas_Imp_Mar cte Join tipo_taxa taxa_ofc on taxa_ofc.cd_tp_tx = cte.cd_tp_tx 
		left join paridade par on par.cd_tp_moeda = cte.cd_tp_moeda and par.cd_tp_par = 'IMM' and par.dt_par = cte.dt_ins_MIM 
		left join Caixa_Mas_Imp_Mar Cxa on Cxa.Num_Proc_MIM = Cte.Num_Proc_MIM and Cxa.DC_MIM = Cte.DC_MIM and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx AND CXA.NUM_LCTO <> 'PROVISÓRIO'  and month(convert(datetime, cxa.dt_pgto_rcto_mim, 105)) = @Mes and year(convert(datetime, cxa.dt_pgto_rcto_mim, 105)) = @Ano 
		join pessoa pes on pes.cd_pes = cte.cd_cred_dev_mim 
	Where 
		DESP_ORG_MIM = 'N' and Cte.Cd_Tp_Tx not in (Select Cd_Tp_Tx From Param_AekContabil_Taxas_Exc) and 
		month(convert(datetime, cte.dt_ins_MIM, 105)) = @Mes and year(convert(datetime, cte.dt_ins_MIM, 105)) = @Ano  and left(cte.cd_tp_tx, 1) <> 'X' and Val_Con_Comp is null

	Union 

	Select 
		Cte.cd_tp_moeda, dt_ins_MIA dt_ins, cte.num_proc_MIA num_proc, cte.dc_MIA dc, (case when cte.cd_tp_moeda = 'REL' then 1 else par_moeda end) par_moeda , 
		taxa_ofc.cd_tp_tx, taxa_ofc.cd_tp_tx cd_tp_tx, taxa_ofc.nome_tp_tx desc_taxa, vlr_org_MIA vlr_org , cxa.vlr_pgto_rcto_MIA vlr_pgto, 
		pes.nome_raz_soc cred_dev, dt_pgto_rcto_mia dt_pgto, Vlr_Contab Vlr_DS4
	from 	
		Cta_Cte_Mas_Imp_Aer cte Join tipo_taxa taxa_ofc on taxa_ofc.cd_tp_tx = cte.cd_tp_tx 
		left join paridade par on par.cd_tp_moeda = cte.cd_tp_moeda and par.cd_tp_par = 'IMA' and par.dt_par = cte.dt_ins_MIA 
		left join Caixa_Mas_Imp_Aer Cxa on Cxa.Num_Proc_MIA = Cte.Num_Proc_MIA and Cxa.DC_MIA = Cte.DC_MIA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx AND CXA.NUM_LCTO <> 'PROVISÓRIO'  and month(convert(datetime, cxa.dt_pgto_rcto_mia, 105)) = @Mes and year(convert(datetime, cxa.dt_pgto_rcto_mia, 105)) = @Ano 
		join pessoa pes on pes.cd_pes = cte.cd_cred_dev_mia 
	Where 
		DESP_ORG_MIA = 'N' and Cte.Cd_Tp_Tx not in (Select Cd_Tp_Tx From Param_AekContabil_Taxas_Exc) and 
		month(convert(datetime, cte.dt_ins_MIA, 105)) = @Mes and year(convert(datetime, cte.dt_ins_MIA, 105)) = @Ano  and left(cte.cd_tp_tx, 1) <> 'X' and Val_Con_Comp is null


	Union 

	Select 
		Cte.cd_tp_moeda, dt_ins_MEM dt_ins, cte.num_proc_MEM num_proc, cte.dc_MEM dc, (case when cte.cd_tp_moeda = 'REL' then 1 else par_moeda end) par_moeda , 
		taxa_ofc.cd_tp_tx, taxa_ofc.cd_tp_tx cd_tp_tx, taxa_ofc.nome_tp_tx desc_taxa, vlr_org_MEM vlr_org, cxa.vlr_pgto_rcto_MEM vlr_pgto, 
		pes.nome_raz_soc cred_dev, dt_pgto_rcto_mem dt_pgto, Vlr_Contab Vlr_DS4
	from 	
		Cta_Cte_Mas_Exp_Mar cte Join tipo_taxa taxa_ofc on taxa_ofc.cd_tp_tx = cte.cd_tp_tx 
		left join paridade par on par.cd_tp_moeda = cte.cd_tp_moeda and par.cd_tp_par = 'EXM' and par.dt_par = cte.dt_ins_MEM 
		left join Caixa_Mas_Exp_Mar Cxa on Cxa.Num_Proc_MEM = Cte.Num_Proc_MEM and Cxa.DC_MEM = Cte.DC_MEM and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx AND CXA.NUM_LCTO <> 'PROVISÓRIO'  and month(convert(datetime, cxa.dt_pgto_rcto_mem, 105)) = @Mes and year(convert(datetime, cxa.dt_pgto_rcto_mem, 105)) = @Ano 
		join pessoa pes on pes.cd_pes = cte.cd_cred_dev_mem 
	Where 
		DESP_DST_MEM = 'N' and Cte.Cd_Tp_Tx not in (Select Cd_Tp_Tx From Param_AekContabil_Taxas_Exc) and 
		month(convert(datetime, cte.dt_ins_MEM, 105)) = @Mes and year(convert(datetime, cte.dt_ins_MEM, 105)) = @Ano  and left(cte.cd_tp_tx, 1) <> 'X' and Val_Con_Comp is null

	Union 

	Select 
		Cte.cd_tp_moeda, dt_ins_MEA dt_ins, cte.num_proc_MEA num_proc, cte.dc_MEA dc, (case when cte.cd_tp_moeda = 'REL' then 1 else par_moeda end) par_moeda , 
		taxa_ofc.cd_tp_tx, taxa_ofc.cd_tp_tx cd_tp_tx, taxa_ofc.nome_tp_tx desc_taxa, vlr_org_MEA vlr_org, cxa.vlr_pgto_rcto_MEA vlr_pgto, 
		pes.nome_raz_soc cred_dev, dt_pgto_rcto_mea dt_pgto, Vlr_Contab Vlr_DS4
	from 	
		Cta_Cte_Mas_Exp_Aer cte Join tipo_taxa taxa_ofc on taxa_ofc.cd_tp_tx = cte.cd_tp_tx 
		left join paridade par on par.cd_tp_moeda = cte.cd_tp_moeda and par.cd_tp_par = 'EXA' and par.dt_par = cte.dt_ins_MEA 
		left join Caixa_Mas_Exp_Aer Cxa on Cxa.Num_Proc_MEA = Cte.Num_Proc_MEA and Cxa.DC_MEA = Cte.DC_MEA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx AND CXA.NUM_LCTO <> 'PROVISÓRIO'  and month(convert(datetime, cxa.dt_pgto_rcto_mea, 105)) = @Mes and year(convert(datetime, cxa.dt_pgto_rcto_mea, 105)) = @Ano 
		join pessoa pes on pes.cd_pes = cte.cd_cred_dev_mea 
	Where 
		DESP_DST_MEA = 'N' and Cte.Cd_Tp_Tx not in (Select Cd_Tp_Tx From Param_AekContabil_Taxas_Exc) and 
		month(convert(datetime, cte.dt_ins_MEA, 105)) = @Mes and year(convert(datetime, cte.dt_ins_MEA, 105)) = @Ano and 
		cte.cd_tp_tx not in ('DS1', 'DS2', 'DS3', 'DS4') and cte.cd_tp_Tx not like '%£%' and left(cte.cd_tp_tx, 1) <> 'X' and Val_Con_Comp is null
GO
