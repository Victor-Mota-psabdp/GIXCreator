SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--spStatement_New_Rel '2014/01/01','2014/11/30','2015/11/30','','Agents'
--alterado os caixas pra pegar da vwcxas
--alterado a paridade pra ser a divisão do Pgto pelo Ref
CREATE    Procedure [dbo].[spStatement_New_Rel]
	@DataInicial	VarChar(10),
	@DataFinal	VarChar(10),
	@DataPgto	VarChar(10),
	@Agente		Varchar(30),
	@Tipo		Char(10)

AS
If @Tipo='Agents'
	BEGIN
		select 
			AX.id_Ax [AX Doc], 
			Dt_Ins_Hia [Date],
			MAWB_HIA [MAWB/MBL],
			Hawb_Hia [HAWB/HBL], 
			CTA.Num_Proc_hia [BDP  Reference],
			Apelido [Creditor / Debitor],
			Nome_tp_TX_ing [Charge Name],
			Nome_tp_Moeda [Currency],
			cta.dc_hia [D / C],
			vlr_org_hia [Value],
			fatcod [Agent-Invoice],
			cta.cd_tp_moeda [Currency Code],
			PAR.Par_Moeda [Exchange Rate]
		From 
			vwcta_cte CTA with(nolock)
			Join House_Imp_Aer HOU with(nolock) on hou.num_proc_hia=cta.num_proc_hia
			Left Join vwcxas CXA with(nolock) on CTA.num_proc_hia=CXA.num_proc_hia AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_HIA=CXA.DC_HIA and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_hia,105)<=@DataPgto
			Join Pessoa PP with(nolock) on PP.cd_pes=cd_cred_dev_hia
			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=cta.CD_tP_tX
			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=cta.cd_tp_moeda
--			Join Master_Imp_Aer MAS on mas.num_proc_mia=hou.num_proc_mia
			Left Join Item_Fat IT with(nolock) on CTA.num_proc_hia=IT.num_proc and cta.cd_tp_Tx=it.cd_tp_tx and cta.dc_hia=it.dc and fatcod in (select fatcod from fatura with(nolock) where fatstatus = 1 and left(fatcod,16)=cta.num_proc_hia)
			Left Join Paridade PAr with(nolock) on CTA.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC' and convert(datetime,Dt_par,105)=convert(varchar(10),getdatE(),110)
			Left Join vwAXDocs AX  with(nolock) on CTA.Num_Proc_HIA=ax.num_proc and cta.Cd_Tp_Tx=AX.cd_tp_tx_Atl and CTA.DC_HIA=ax.dc 
		Where
			cd_Tp_Ativ='AGT' and desp_org_hia='N' and cxa.num_lcto is null
			and convert(datetime,dt_ins_hia,105) between @DataInicial and @DataFinal
			--and apelido like @Agente 	
			--and @Agente='%'  or @Agente=''
			and (Apelido = @Agente or @Agente = 'ALL')
		UNION ALL

--MASTER
		select 
		AX.id_Ax [AX Doc], 
		Dt_Ins_Hia [Date],
		MAWB_MIA [MAWB/MBL],
		'' [HAWB/HBL],
		CTA.Num_Proc_hia [BDP  Reference],
		Apelido [Creditor / Debitor],
		Nome_tp_TX_ing [Charge Name],
		Nome_tp_Moeda [Currency],
		cta.dc_hia [D / C],
		vlr_org_hia [Value],
		fatcod [Agent-Invoice],
		cta.cd_tp_moeda [Currency Code],
		PAR.Par_Moeda [Exchange Rate]
		From 
			vwcta_Cte CTA with(nolock)
			Join Master_Imp_Aer HOU with(nolock) on hou.num_proc_mia=cta.num_proc_hia
			Left Join vwcxas CXA with(nolock) on CTA.num_proc_hia=CXA.num_proc_hia AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_hIA=CXA.DC_hIA and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_hia,105)<=@DataPgto
			Join Pessoa PP with(nolock) on PP.cd_pes=cd_cred_dev_hia
			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=cta.CD_tP_tX
			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=cta.cd_tp_moeda
			Left Join Item_Fat IT with(nolock) on CTA.num_proc_hia=IT.num_proc and cta.cd_tp_Tx=it.cd_tp_tx and cta.dc_hia=it.dc and fatcod in (select fatcod from fatura with(nolock) where fatstatus = 1 and left(fatcod,16)=cta.num_proc_hia)
			Left Join Paridade PAr with(nolock) on CTA.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC' and convert(datetime,Dt_par,105)=convert(varchar(10),getdatE(),110)
			Left Join vwAXDocs AX  with(nolock) on CTA.Num_Proc_hIA =ax.num_proc and cta.Cd_Tp_Tx=AX.cd_tp_tx_Atl and CTA.DC_hIA=ax.dc 

		Where
			cd_Tp_Ativ='AGT' and desp_org_hia='N' and cxa.num_lcto is null
			and convert(datetime,dt_ins_hia,105) between @DataInicial and @DataFinal
			--and apelido like @Agente	
			--and @Agente='%'  or @Agente=''
			and (Apelido = @Agente or @Agente = 'ALL')
	END
		
ELSE
	BEGIN
		select 
			AX.id_Ax [AX Doc],
			Dt_Ins_Hia [Date],
			MAWB_HIA [MAWB/MBL],
			Hawb_Hia [HAWB/HBL],
			CTA.Num_Proc_hia [BDP  Reference],
			Apelido [Creditor / Debitor],
			Nome_tp_TX_ing [Charge Name],
			Nome_tp_Moeda [Currency],
			cta.dc_hia [D / C],
			vlr_org_hia [Value],
			NULL [Agent-Invoice],
			cta.cd_tp_moeda [Currency Code],
			cxa.Vlr_Pgto_Rcto_HIA / cxa.Vlr_Ref_HIA [Exchange Rate]
		From 
			vwcta_Cte CTA with(nolock)
			Join House_Imp_Aer HOU with(nolock) on hou.num_proc_hia=cta.num_proc_hia
			Left Join vwcxas CXA with(nolock) on CTA.num_proc_hia=CXA.num_proc_hia AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_HIA=CXA.DC_HIA and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_hia,105)<=@DataPgto
			Join Pessoa PP with(nolock) on PP.cd_pes=cd_cred_dev_hia
			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=cta.CD_tP_tX
			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=cta.cd_tp_moeda
--			Join Master_Imp_Aer MAS on mas.num_proc_mia=hou.num_proc_mia
			Left Join vwAXDocs AX  with(nolock) on CTA.Num_Proc_HIA =ax.num_proc and cta.Cd_Tp_Tx=AX.cd_tp_tx_Atl and CTA.DC_HIA  =ax.dc 

		Where
			cd_Tp_Ativ='AGT' and desp_org_hia='N' and cxa.num_lcto is NOT null
			and convert(datetime,dt_ins_hia,105) between @DataInicial and @DataFinal
			--and apelido like @Agente	
			--and @Agente='%'  or @Agente=''
			and (Apelido = @Agente or @Agente = 'ALL')
--MASTER
		UNION ALL
		select 
			AX.id_Ax [AX Doc],
			Dt_Ins_Hia [Date],
			MAWB_MIA [MAWB/MBL],
			'' [HAWB/HBL],
			CTA.Num_Proc_hia [BDP  Reference],
			Apelido [Creditor / Debitor],
			Nome_tp_TX_ing [Charge Name],
			Nome_tp_Moeda [Currency],
			cta.dc_hia [D / C],
			vlr_org_hia [Value],
			NULL [Agent-Invoice],
			cta.cd_tp_moeda [Currency Code],
			cxa.Vlr_Pgto_Rcto_HIA / cxa.Vlr_Ref_HIA [Exchange Rate]
		From 
			vwcta_Cte CTA with(nolock)
			Join MASTER_Imp_Aer HOU with(nolock) on hou.num_proc_MIA=cta.num_proc_hIA
			Left Join vwcxas CXA with(nolock) on CTA.num_proc_hIA=CXA.num_proc_hia AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_hIA=CXA.DC_hia and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_hia,105)<=@DataPgto
			Join Pessoa PP with(nolock) on PP.cd_pes=cd_cred_dev_hIA
			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=cta.CD_tP_tX
			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=cta.cd_tp_moeda
			Left Join vwAXDocs AX  with(nolock) on CTA.Num_Proc_hIA  =ax.num_proc and cta.Cd_Tp_Tx=AX.cd_tp_tx_Atl and CTA.DC_hIA  =ax.dc 

		Where
			cd_Tp_Ativ='AGT' and desp_org_hIA='N' and cxa.num_lcto is NOT null
			and convert(datetime,dt_ins_hIA,105) between @DataInicial and @DataFinal
			--and apelido like @Agente
			--and @Agente='%'  or @Agente=''
			and (Apelido = @Agente or @Agente = 'ALL')
	END


GO
