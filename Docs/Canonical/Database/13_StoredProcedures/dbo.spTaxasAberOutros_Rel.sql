SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO







CREATE  Procedure spTaxasAberOutros_Rel
		@DataInicial	VarChar(10),
		@DataFinal	VarChar(10),
		@DataPgto	VarChar(10),
		@Agente		Varchar(30),
		@Tipo		Char(1)



AS

If @Tipo='A'	
	BEGIN
		select 
			Dt_Ins_Hia Data,MAWB_MIA,CTA.Num_Proc_hia,Apelido,Nome_tp_TX_ing,Hawb_Hia,Nome_tp_Moeda,cta.dc_hia,vlr_org_hia,Num_DCN_HIA,cta.cd_tp_moeda,PAR.Par_Moeda Paridade
		From 
			cta_cte_hou_imp_aer CTA
			Join House_Imp_Aer HOU on hou.num_proc_hia=cta.num_proc_hia
			Left Join Caixa_hou_imp_aer CXA on CTA.num_proc_hia=CXA.num_proc_hia AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_HIA=CXA.DC_HIA and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_hia,105)<=@DataPgto
			Join Pessoa PP on PP.cd_pes=cd_cred_dev_hia
			Join Tipo_Taxa TT on TT.cd_tp_tx=cta.CD_tP_tX
			Join Tipo_Moeda TM on TM.cd_tp_moeda=cta.cd_tp_moeda
			Join Master_Imp_Aer MAS on mas.num_proc_mia=hou.num_proc_mia
			Left Join Paridade PAr on CTA.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC' and convert(datetime,Dt_par,105)=dbo.hoje(getdate())
		Where
			cd_Tp_Ativ<>'AGT' and desp_org_hia='N' and cxa.num_lcto is null
			and convert(datetime,dt_ins_hia,105) between @DataInicial and @DataFinal
			and apelido like @Agente and left(hou.num_proc_hia,5)<>'IAJOB'

		UNION

		select 
			Dt_Ins_Hea Data, MAWB_MEA,CTA.Num_Proc_Hea,Apelido,Nome_tp_TX_ing,Hawb_hea,Nome_tp_Moeda,cta.dc_hea,vlr_org_hea,Num_DCN_hea,cta.cd_Tp_moeda,PAR.Par_Moeda Paridade
		From 
			cta_cte_hou_exp_aer CTA
			Join House_exp_Aer HOU on hou.num_proc_hea=cta.num_proc_hea
			Left Join Caixa_hou_exp_aer CXA on CTA.num_proc_hea=CXA.num_proc_hea AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_hea=CXA.DC_hea and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_hea,105)<=@DataPgto
			Join Pessoa PP on PP.cd_pes=cd_cred_dev_hea
			Join Tipo_Taxa TT on TT.cd_tp_tx=cta.CD_tP_tX
			Join Tipo_Moeda TM on TM.cd_tp_moeda=cta.cd_tp_moeda
			Join Master_Exp_Aer mas on mas.num_proc_mea=hou.num_proc_mea
			Left Join Paridade PAr on CTA.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC' and convert(datetime,Dt_par,105)=dbo.hoje(getdate())

		Where
			cd_Tp_Ativ<>'AGT' and desp_DST_hea='N' and cxa.num_lcto is null
			and convert(datetime,dt_ins_hea,105) between @DataInicial and @DataFinal
			and apelido like @Agente and left(hou.num_proc_hea,5)<>'EAJOB'
		UNION

		select 
			Dt_Ins_Him Data,MAWB_MIM,CTA.num_proc_Him,Apelido,Nome_tp_TX_ing,Hawb_HIM,Nome_tp_Moeda,cta.dc_HIM,vlr_org_HIM,Num_DCN_HIM,cta.cd_tp_moeda,PAR.Par_Moeda Paridade
		From 
			cta_cte_hou_imp_MAR CTA
			Join House_Imp_MAR HOU on hou.num_proc_HIM=cta.num_proc_HIM
			Left Join Caixa_hou_imp_MAR CXA on CTA.num_proc_HIM=CXA.num_proc_HIM AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_HIM=CXA.DC_HIM and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_HIM,105)<=@DataPgto
			Join Pessoa PP on PP.cd_pes=cd_cred_dev_HIM
			Join Tipo_Taxa TT on TT.cd_tp_tx=cta.CD_tP_tX
			Join Tipo_Moeda TM on TM.cd_tp_moeda=cta.cd_tp_moeda
			Join Master_Imp_Mar mas on mas.num_proc_mim=hou.num_proc_mim
			Left Join Paridade PAr on CTA.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC' and convert(datetime,Dt_par,105)=dbo.hoje(getdate())
		Where
			cd_Tp_Ativ<>'AGT' and desp_org_HIM='N' and cxa.num_lcto is null
			and convert(datetime,dt_ins_HIM,105) between @DataInicial and @DataFinal
			and apelido like @Agente and left(hou.num_proc_him,5)<>'IMJOB'

		UNION

		select 
			Dt_Ins_Hem Data, MaWB_MEM,CTA.num_proc_hem,Apelido,Nome_tp_TX_ing,Hawb_HEM,Nome_tp_Moeda,cta.dc_HEM,vlr_org_HEM,Num_DCN_HEM ,cta.cd_Tp_moeda,PAR.Par_Moeda Paridade
		From 
			cta_cte_hou_exp_MAR CTA
			Join House_exp_MAR HOU on hou.num_proc_HEM=cta.num_proc_HEM
			Left Join Caixa_hou_exp_MAR CXA on CTA.num_proc_HEM=CXA.num_proc_HEM AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_HEM=CXA.DC_HEM and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_HEM,105)<=@DataPgto
			Join Pessoa PP on PP.cd_pes=cd_cred_dev_HEM
			Join Tipo_Taxa TT on TT.cd_tp_tx=cta.CD_tP_tX
			Join Tipo_Moeda TM on TM.cd_tp_moeda=cta.cd_tp_moeda
			Join Master_Exp_Mar mas on mas.num_proc_mem=hou.num_proc_mem
			Left Join Paridade PAr on CTA.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC' and convert(datetime,Dt_par,105)=dbo.hoje(getdate())
		Where
			cd_Tp_Ativ<>'AGT' and desp_DST_HEM='N' and cxa.num_lcto is null
			and convert(datetime,dt_ins_HEM,105) between @DataInicial and @DataFinal
			and apelido like @Agente and left(hou.num_proc_hem,5)<>'EMJOB'

		UNION

		select 
			Dt_Ins_Mia Data,MAWB_MIA,CTA.Num_Proc_Mia,Apelido,Nome_tp_TX_ing,Null,Nome_tp_Moeda,cta.dc_Mia,vlr_org_Mia,Num_DCN_MIA,cta.cd_tp_moeda,PAR.Par_Moeda Paridade
		From 
			cta_cte_MAS_imp_aer CTA
			Left Join Caixa_MAS_imp_aer CXA on CTA.num_proc_Mia=CXA.num_proc_Mia AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_MIA=CXA.DC_MIA and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_Mia,105)<=@DataPgto
			Join Pessoa PP on PP.cd_pes=cd_cred_dev_Mia
			Join Tipo_Taxa TT on TT.cd_tp_tx=cta.CD_tP_tX
			Join Tipo_Moeda TM on TM.cd_tp_moeda=cta.cd_tp_moeda
			Join Master_Imp_Aer MAS on mas.num_proc_mia=CTA.num_proc_mia
			Left Join Paridade PAr on CTA.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC' and convert(datetime,Dt_par,105)=dbo.hoje(getdate())
		Where
			cd_Tp_Ativ<>'AGT' and desp_org_Mia='N' and cxa.num_lcto is null
			and convert(datetime,dt_ins_Mia,105) between @DataInicial and @DataFinal
			and apelido like @Agente 

		union
		select 
			Dt_Ins_MEA Data,MAWB_MEA,CTA.Num_Proc_MEA,Apelido,Nome_tp_TX_ing,Null,Nome_tp_Moeda,cta.dc_MEA,vlr_org_MEA,Num_DCN_MEA,cta.cd_tp_moeda,PAR.Par_Moeda Paridade
		From 
			cta_cte_MAS_EXP_aer CTA
			Left Join Caixa_MAS_EXP_aer CXA on CTA.num_proc_MEA=CXA.num_proc_MEA AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_MEA=CXA.DC_MEA and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_MEA,105)<=@DataPgto
			Join Pessoa PP on PP.cd_pes=cd_cred_dev_MEA
			Join Tipo_Taxa TT on TT.cd_tp_tx=cta.CD_tP_tX
			Join Tipo_Moeda TM on TM.cd_tp_moeda=cta.cd_tp_moeda
			Join Master_EXP_Aer MAS on mas.num_proc_MEA=CTA.num_proc_MEA
			Left Join Paridade PAr on CTA.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC' and convert(datetime,Dt_par,105)=dbo.hoje(getdate())
		Where
			cd_Tp_Ativ<>'AGT' and desp_dst_MEA='N' and cxa.num_lcto is null
			and convert(datetime,dt_ins_MEA,105) between @DataInicial and @DataFinal
			and apelido like @Agente 

		UNION
		select 
			Dt_Ins_mim Data,MAWB_mim,CTA.Num_Proc_mim,Apelido,Nome_tp_TX_ing,Null,Nome_tp_Moeda,cta.dc_mim,vlr_org_mim,Num_DCN_mim,cta.cd_tp_moeda,PAR.Par_Moeda Paridade
		From 
			cta_cte_MAS_imp_mar CTA
			Left Join Caixa_MAS_imp_mar CXA on CTA.num_proc_mim=CXA.num_proc_mim AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_mim=CXA.DC_mim and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_mim,105)<=@DataPgto
			Join Pessoa PP on PP.cd_pes=cd_cred_dev_mim
			Join Tipo_Taxa TT on TT.cd_tp_tx=cta.CD_tP_tX
			Join Tipo_Moeda TM on TM.cd_tp_moeda=cta.cd_tp_moeda
			Join Master_Imp_mar MAS on mas.num_proc_mim=CTA.num_proc_mim
			Left Join Paridade PAr on CTA.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC' and convert(datetime,Dt_par,105)=dbo.hoje(getdate())
		Where
			cd_Tp_Ativ<>'AGT' and desp_org_mim='N' and cxa.num_lcto is null
			and convert(datetime,dt_ins_mim,105) between @DataInicial and @DataFinal
			and apelido like @Agente 

		union

		select 
			Dt_Ins_mem Data,MAWB_mem,CTA.Num_Proc_mem,Apelido,Nome_tp_TX_ing,Null,Nome_tp_Moeda,cta.dc_mem,vlr_org_mem,Num_DCN_mem,cta.cd_tp_moeda,PAR.Par_Moeda Paridade
		From 
			cta_cte_MAS_EXP_mar CTA
			Left Join Caixa_MAS_EXP_mar CXA on CTA.num_proc_mem=CXA.num_proc_mem AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_mem=CXA.DC_mem and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_mem,105)<=@DataPgto
			Join Pessoa PP on PP.cd_pes=cd_cred_dev_mem
			Join Tipo_Taxa TT on TT.cd_tp_tx=cta.CD_tP_tX
			Join Tipo_Moeda TM on TM.cd_tp_moeda=cta.cd_tp_moeda
			Join Master_EXP_mar MAS on mas.num_proc_mem=CTA.num_proc_mem
			Left Join Paridade PAr on CTA.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC' and convert(datetime,Dt_par,105)=dbo.hoje(getdate())
		Where
			cd_Tp_Ativ<>'AGT' and desp_dst_mem='N' and cxa.num_lcto is null
			and convert(datetime,dt_ins_mem,105) between @DataInicial and @DataFinal
			and apelido like @Agente 


	END

GO
