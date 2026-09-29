SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[pAeKContProcessos_Rel]
	@Ano	varchar(4),
	@Mes	varchar(2)

AS
	Set @Ano = '2007'
	Set @Mes = '10'

	Select 
		Cte.cd_tp_moeda, dt_ins_him dt_ins, cte.num_proc_him num_proc, cte.dc_him dc, 
		(case when cte.cd_tp_moeda = 'REL' then 1 else par.par_moeda end) par_moeda , 
		(case when cte.cd_tp_moeda = 'REL' then 1 else par2.par_moeda end) par_moeda2 , 
		taxa_ofc.cd_tp_tx, taxa_ofc.cd_tp_tx cd_tp_tx, taxa_ofc.nome_tp_tx desc_taxa, 
		vlr_org_him vlr_org, cxa.vlr_pgto_rcto_him vlr_pgto, 
		pes.nome_raz_soc cred_dev, dt_pgto_rcto_him dt_pgto, 
		Vlr_Contab 
	from 	
		Cta_Cte_Hou_Imp_Mar cte Join tipo_taxa taxa_ofc on taxa_ofc.cd_tp_tx = cte.cd_tp_tx 
		left join paridade par on par.cd_tp_moeda = cte.cd_tp_moeda and par.cd_tp_par = 'IMM' and par.dt_par = cte.dt_ins_him 
		left join paridade par2 on par2.cd_tp_moeda = cte.cd_tp_moeda and par2.cd_tp_par = 'IMM' and convert(datetime, par2.dt_par, 105) in 
		(Select top 1 convert(datetime, parlist.dt_par, 105) from paridade parlist where convert(datetime, parlist.dt_par, 105) > convert(datetime,cte.dt_ins_him, 105)  and  parlist.cd_tp_moeda = cte.cd_tp_moeda and parlist.cd_tp_par = 'IMM' )
		left join Caixa_Hou_Imp_Mar Cxa on Cxa.Num_Proc_HIM = Cte.Num_Proc_HIM and Cxa.DC_HIM = Cte.DC_HIM and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx AND CXA.NUM_LCTO <> 'PROVISÓRIO' 
		join pessoa pes on pes.cd_pes = cte.cd_cred_dev_him 
	Where 
		DESP_ORG_HIM = 'N' and Cte.Cd_Tp_Tx not in (Select Cd_Tp_Tx From Param_AekContabil_Taxas_Exc) and 
		year(convert(datetime, cte.dt_ins_him, 105)) = @Ano and 
		month(convert(datetime, cte.dt_ins_him, 105)) = @Mes and 			
		left(cte.num_proc_him, 5) <> 'IMJOB' and left(cte.cd_tp_Tx, 1) <> 'X'


	Union

	Select 
		Cte.cd_tp_moeda, dt_ins_hia dt_ins, cte.num_proc_hia num_proc, cte.dc_hia dc, 
		(case when cte.cd_tp_moeda = 'REL' then 1 else par.par_moeda end) par_moeda , 
		(case when cte.cd_tp_moeda = 'REL' then 1 else par2.par_moeda end) par_moeda2 , 
		taxa_ofc.cd_tp_tx, taxa_ofc.cd_tp_tx cd_tp_tx, taxa_ofc.nome_tp_tx desc_taxa, 
		vlr_org_hia vlr_org, cxa.vlr_pgto_rcto_hia vlr_pgto, 
		pes.nome_raz_soc cred_dev, dt_pgto_rcto_hia dt_pgto, 
		Vlr_Contab 
	from 	
		Cta_Cte_Hou_Imp_aer cte Join tipo_taxa taxa_ofc on taxa_ofc.cd_tp_tx = cte.cd_tp_tx 
		left join paridade par on par.cd_tp_moeda = cte.cd_tp_moeda and par.cd_tp_par = 'IMA' and par.dt_par = cte.dt_ins_hia 
		left join paridade par2 on par2.cd_tp_moeda = cte.cd_tp_moeda and par2.cd_tp_par = 'IMA' and convert(datetime, par2.dt_par, 105) in 
		(Select top 1 convert(datetime, parlist.dt_par, 105) from paridade parlist where convert(datetime, parlist.dt_par, 105) > convert(datetime,cte.dt_ins_hia, 105)  and  parlist.cd_tp_moeda = cte.cd_tp_moeda and parlist.cd_tp_par = 'IMA' )
		left join Caixa_Hou_Imp_aer Cxa on Cxa.Num_Proc_hia = Cte.Num_Proc_hia and Cxa.DC_hia = Cte.DC_hia and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx AND CXA.NUM_LCTO <> 'PROVISÓRIO' 
		join pessoa pes on pes.cd_pes = cte.cd_cred_dev_hia 
	Where 
		DESP_ORG_hia = 'N' and Cte.Cd_Tp_Tx not in (Select Cd_Tp_Tx From Param_AekContabil_Taxas_Exc) and 
		year(convert(datetime, cte.dt_ins_hia, 105)) = @Ano and 
		month(convert(datetime, cte.dt_ins_hia, 105)) = @Mes and 			
		left(cte.num_proc_hia, 5) <> 'IAJOB' and left(cte.cd_tp_Tx, 1) <> 'X'
	
	Union

	Select 
		Cte.cd_tp_moeda, dt_ins_hem dt_ins, cte.num_proc_hem num_proc, cte.dc_hem dc, 
		(case when cte.cd_tp_moeda = 'REL' then 1 else par.par_moeda end) par_moeda , 
		(case when cte.cd_tp_moeda = 'REL' then 1 else par2.par_moeda end) par_moeda2 , 
		taxa_ofc.cd_tp_tx, taxa_ofc.cd_tp_tx cd_tp_tx, taxa_ofc.nome_tp_tx desc_taxa, 
		vlr_org_hem vlr_org, cxa.vlr_pgto_rcto_hem vlr_pgto, 
		pes.nome_raz_soc cred_dev, dt_pgto_rcto_hem dt_pgto, 
		Vlr_Contab 
	from 	
		Cta_Cte_Hou_exp_Mar cte Join tipo_taxa taxa_ofc on taxa_ofc.cd_tp_tx = cte.cd_tp_tx 
		left join paridade par on par.cd_tp_moeda = cte.cd_tp_moeda and par.cd_tp_par = 'EXM' and par.dt_par = cte.dt_ins_hem 
		left join paridade par2 on par2.cd_tp_moeda = cte.cd_tp_moeda and par2.cd_tp_par = 'EXM' and convert(datetime, par2.dt_par, 105) in 
		(Select top 1 convert(datetime, parlist.dt_par, 105) from paridade parlist where convert(datetime, parlist.dt_par, 105) > convert(datetime,cte.dt_ins_hem, 105)  and  parlist.cd_tp_moeda = cte.cd_tp_moeda and parlist.cd_tp_par = 'EXM' )
		left join Caixa_Hou_exp_Mar Cxa on Cxa.Num_Proc_hem = Cte.Num_Proc_hem and Cxa.DC_hem = Cte.DC_hem and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx AND CXA.NUM_LCTO <> 'PROVISÓRIO' 
		join pessoa pes on pes.cd_pes = cte.cd_cred_dev_hem 
	Where 
		DESP_DST_hem = 'N' and Cte.Cd_Tp_Tx not in (Select Cd_Tp_Tx From Param_AekContabil_Taxas_Exc) and 
		year(convert(datetime, cte.dt_ins_hem, 105)) = @Ano and 
		month(convert(datetime, cte.dt_ins_hem, 105)) = @Mes and 			
		left(cte.num_proc_hem, 5) <> 'EMJOB' and left(cte.cd_tp_Tx, 1) <> 'X'

	UNION 

	Select 
		Cte.cd_tp_moeda, dt_ins_hea dt_ins, cte.num_proc_hea num_proc, cte.dc_hea dc, 
		(case when cte.cd_tp_moeda = 'REL' then 1 else par.par_moeda end) par_moeda , 
		(case when cte.cd_tp_moeda = 'REL' then 1 else par2.par_moeda end) par_moeda2 , 
		taxa_ofc.cd_tp_tx, taxa_ofc.cd_tp_tx cd_tp_tx, taxa_ofc.nome_tp_tx desc_taxa, 
		vlr_org_hea vlr_org, cxa.vlr_pgto_rcto_hea vlr_pgto, 
		pes.nome_raz_soc cred_dev, dt_pgto_rcto_hea dt_pgto, 
		Vlr_Contab 
	from 	
		Cta_Cte_Hou_exp_aer cte Join tipo_taxa taxa_ofc on taxa_ofc.cd_tp_tx = cte.cd_tp_tx 
		left join paridade par on par.cd_tp_moeda = cte.cd_tp_moeda and par.cd_tp_par = 'EXA' and par.dt_par = cte.dt_ins_hea 
		left join paridade par2 on par2.cd_tp_moeda = cte.cd_tp_moeda and par2.cd_tp_par = 'EXA' and convert(datetime, par2.dt_par, 105) in 
		(Select top 1 convert(datetime, parlist.dt_par, 105) from paridade parlist where convert(datetime, parlist.dt_par, 105) > convert(datetime,cte.dt_ins_hea, 105)  and  parlist.cd_tp_moeda = cte.cd_tp_moeda and parlist.cd_tp_par = 'EXA' )
		left join Caixa_Hou_exp_aer Cxa on Cxa.Num_Proc_hea = Cte.Num_Proc_hea and Cxa.DC_hea = Cte.DC_hea and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx AND CXA.NUM_LCTO <> 'PROVISÓRIO' 
		join pessoa pes on pes.cd_pes = cte.cd_cred_dev_hea 
	Where 
		DESP_DST_hea = 'N' and Cte.Cd_Tp_Tx not in (Select Cd_Tp_Tx From Param_AekContabil_Taxas_Exc) and 
		year(convert(datetime, cte.dt_ins_hea, 105)) = @Ano and 
		month(convert(datetime, cte.dt_ins_hea, 105)) = @Mes and 			
		left(cte.num_proc_hea, 5) <> 'EMJOB' and left(cte.cd_tp_Tx, 1) <> 'X'



	uNION 



	Select 
		Cte.cd_tp_moeda, dt_ins_MIM dt_ins, cte.num_proc_MIM num_proc, cte.dc_MIM dc, 
		(case when cte.cd_tp_moeda = 'REL' then 1 else par.par_moeda end) par_moeda , 
		(case when cte.cd_tp_moeda = 'REL' then 1 else par2.par_moeda end) par_moeda2 , 
		taxa_ofc.cd_tp_tx, taxa_ofc.cd_tp_tx cd_tp_tx, taxa_ofc.nome_tp_tx desc_taxa, 
		vlr_org_MIM vlr_org, cxa.vlr_pgto_rcto_MIM vlr_pgto, 
		pes.nome_raz_soc cred_dev, dt_pgto_rcto_MIM dt_pgto, 
		Vlr_Contab 
	from 	
		Cta_Cte_MAS_Imp_Mar cte Join tipo_taxa taxa_ofc on taxa_ofc.cd_tp_tx = cte.cd_tp_tx 
		left join paridade par on par.cd_tp_moeda = cte.cd_tp_moeda and par.cd_tp_par = 'IMM' and par.dt_par = cte.dt_ins_MIM 
		left join paridade par2 on par2.cd_tp_moeda = cte.cd_tp_moeda and par2.cd_tp_par = 'IMM' and convert(datetime, par2.dt_par, 105) in 
		(Select top 1 convert(datetime, parlist.dt_par, 105) from paridade parlist where convert(datetime, parlist.dt_par, 105) > convert(datetime,cte.dt_ins_MIM, 105)  and  parlist.cd_tp_moeda = cte.cd_tp_moeda and parlist.cd_tp_par = 'IMM' )
		left join Caixa_MAS_Imp_Mar Cxa on Cxa.Num_Proc_MIM = Cte.Num_Proc_MIM and Cxa.DC_MIM = Cte.DC_MIM and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx AND CXA.NUM_LCTO <> 'PROVISÓRIO' 
		join pessoa pes on pes.cd_pes = cte.cd_cred_dev_MIM 
	Where 
		DESP_ORG_MIM = 'N' and Cte.Cd_Tp_Tx not in (Select Cd_Tp_Tx From Param_AekContabil_Taxas_Exc) and 
		year(convert(datetime, cte.dt_ins_MIM, 105)) = @Ano and 
		month(convert(datetime, cte.dt_ins_MIM, 105)) = @Mes and left(cte.cd_tp_Tx, 1) <> 'X'


	Union

	Select 
		Cte.cd_tp_moeda, dt_ins_MIA dt_ins, cte.num_proc_MIA num_proc, cte.dc_MIA dc, 
		(case when cte.cd_tp_moeda = 'REL' then 1 else par.par_moeda end) par_moeda , 
		(case when cte.cd_tp_moeda = 'REL' then 1 else par2.par_moeda end) par_moeda2 , 
		taxa_ofc.cd_tp_tx, taxa_ofc.cd_tp_tx cd_tp_tx, taxa_ofc.nome_tp_tx desc_taxa, 
		vlr_org_MIA vlr_org, cxa.vlr_pgto_rcto_MIA vlr_pgto, 
		pes.nome_raz_soc cred_dev, dt_pgto_rcto_MIA dt_pgto, 
		Vlr_Contab 
	from 	
		Cta_Cte_MAS_Imp_aer cte Join tipo_taxa taxa_ofc on taxa_ofc.cd_tp_tx = cte.cd_tp_tx 
		left join paridade par on par.cd_tp_moeda = cte.cd_tp_moeda and par.cd_tp_par = 'IMA' and par.dt_par = cte.dt_ins_MIA 
		left join paridade par2 on par2.cd_tp_moeda = cte.cd_tp_moeda and par2.cd_tp_par = 'IMA' and convert(datetime, par2.dt_par, 105) in 
		(Select top 1 convert(datetime, parlist.dt_par, 105) from paridade parlist where convert(datetime, parlist.dt_par, 105) > convert(datetime,cte.dt_ins_MIA, 105)  and  parlist.cd_tp_moeda = cte.cd_tp_moeda and parlist.cd_tp_par = 'IMA' )
		left join Caixa_MAS_Imp_aer Cxa on Cxa.Num_Proc_MIA = Cte.Num_Proc_MIA and Cxa.DC_MIA = Cte.DC_MIA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx AND CXA.NUM_LCTO <> 'PROVISÓRIO' 
		join pessoa pes on pes.cd_pes = cte.cd_cred_dev_MIA 
	Where 
		DESP_ORG_MIA = 'N' and Cte.Cd_Tp_Tx not in (Select Cd_Tp_Tx From Param_AekContabil_Taxas_Exc) and 
		year(convert(datetime, cte.dt_ins_MIA, 105)) = @Ano and 
		month(convert(datetime, cte.dt_ins_MIA, 105)) = @Mes and left(cte.cd_tp_Tx, 1) <> 'X'
	
	Union

	Select 
		Cte.cd_tp_moeda, dt_ins_MEM dt_ins, cte.num_proc_MEM num_proc, cte.dc_MEM dc, 
		(case when cte.cd_tp_moeda = 'REL' then 1 else par.par_moeda end) par_moeda , 
		(case when cte.cd_tp_moeda = 'REL' then 1 else par2.par_moeda end) par_moeda2 , 
		taxa_ofc.cd_tp_tx, taxa_ofc.cd_tp_tx cd_tp_tx, taxa_ofc.nome_tp_tx desc_taxa, 
		vlr_org_MEM vlr_org, cxa.vlr_pgto_rcto_MEM vlr_pgto, 
		pes.nome_raz_soc cred_dev, dt_pgto_rcto_MEM dt_pgto, 
		Vlr_Contab 
	from 	
		Cta_Cte_MAS_exp_Mar cte Join tipo_taxa taxa_ofc on taxa_ofc.cd_tp_tx = cte.cd_tp_tx 
		left join paridade par on par.cd_tp_moeda = cte.cd_tp_moeda and par.cd_tp_par = 'EXM' and par.dt_par = cte.dt_ins_MEM 
		left join paridade par2 on par2.cd_tp_moeda = cte.cd_tp_moeda and par2.cd_tp_par = 'EXM' and convert(datetime, par2.dt_par, 105) in 
		(Select top 1 convert(datetime, parlist.dt_par, 105) from paridade parlist where convert(datetime, parlist.dt_par, 105) > convert(datetime,cte.dt_ins_MEM, 105)  and  parlist.cd_tp_moeda = cte.cd_tp_moeda and parlist.cd_tp_par = 'EXM' )
		left join Caixa_MAS_exp_Mar Cxa on Cxa.Num_Proc_MEM = Cte.Num_Proc_MEM and Cxa.DC_MEM = Cte.DC_MEM and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx AND CXA.NUM_LCTO <> 'PROVISÓRIO' 
		join pessoa pes on pes.cd_pes = cte.cd_cred_dev_MEM 
	Where 
		DESP_DST_MEM = 'N' and Cte.Cd_Tp_Tx not in (Select Cd_Tp_Tx From Param_AekContabil_Taxas_Exc) and 
		year(convert(datetime, cte.dt_ins_MEM, 105)) = @Ano and 
		month(convert(datetime, cte.dt_ins_MEM, 105)) = @Mes and left(cte.cd_tp_Tx, 1) <> 'X'

	UNION 

	Select 
		Cte.cd_tp_moeda, dt_ins_MEA dt_ins, cte.num_proc_MEA num_proc, cte.dc_MEA dc, 
		(case when cte.cd_tp_moeda = 'REL' then 1 else par.par_moeda end) par_moeda , 
		(case when cte.cd_tp_moeda = 'REL' then 1 else par2.par_moeda end) par_moeda2 , 
		taxa_ofc.cd_tp_tx, taxa_ofc.cd_tp_tx cd_tp_tx, taxa_ofc.nome_tp_tx desc_taxa, 
		vlr_org_MEA vlr_org, cxa.vlr_pgto_rcto_MEA vlr_pgto, 
		pes.nome_raz_soc cred_dev, dt_pgto_rcto_MEA dt_pgto, 
		Vlr_Contab 
	from 	
		Cta_Cte_MAS_exp_aer cte Join tipo_taxa taxa_ofc on taxa_ofc.cd_tp_tx = cte.cd_tp_tx 
		left join paridade par on par.cd_tp_moeda = cte.cd_tp_moeda and par.cd_tp_par = 'EXA' and par.dt_par = cte.dt_ins_MEA 
		left join paridade par2 on par2.cd_tp_moeda = cte.cd_tp_moeda and par2.cd_tp_par = 'EXA' and convert(datetime, par2.dt_par, 105) in 
		(Select top 1 convert(datetime, parlist.dt_par, 105) from paridade parlist where convert(datetime, parlist.dt_par, 105) > convert(datetime,cte.dt_ins_MEA, 105)  and  parlist.cd_tp_moeda = cte.cd_tp_moeda and parlist.cd_tp_par = 'EXA' )
		left join Caixa_MAS_exp_aer Cxa on Cxa.Num_Proc_MEA = Cte.Num_Proc_MEA and Cxa.DC_MEA = Cte.DC_MEA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx AND CXA.NUM_LCTO <> 'PROVISÓRIO' 
		join pessoa pes on pes.cd_pes = cte.cd_cred_dev_MEA 
	Where 
		DESP_DST_MEA = 'N' and Cte.Cd_Tp_Tx not in (Select Cd_Tp_Tx From Param_AekContabil_Taxas_Exc) and 
		year(convert(datetime, cte.dt_ins_MEA, 105)) = @Ano and 
		month(convert(datetime, cte.dt_ins_MEA, 105)) = @Mes and left(cte.cd_tp_Tx, 1) <> 'X'


	Order by Num_Proc
GO
