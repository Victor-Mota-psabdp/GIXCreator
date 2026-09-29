SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  Procedure spLucCliente
			(
				@DataInicial	varchar(10),
				@DataFinal	varchar(10),
				@Cliente	varchar(30)
			)

as


Select 
	Hawb_hia HAWB, Apelido Cliente, HOU.num_proc_hia Processo, cta.dc_hia, Nome_Tp_Tx, CTA.cd_tp_moeda, Vlr_org_hia,isnull(Vlr_Pgto_rcto_hia,0) Pgto ,Par_Moeda 
From 
	House_Imp_Aer HOU
	Left Join Cta_Cte_hou_imp_Aer CTA on HOU.num_proc_hia=CTA.num_proc_hia
	Left Join Pessoa PP on PP.cd_pes=Hou.cd_import_hia
	Left Join Master_imp_Aer MAS on MAS.num_proc_mia=HOU.num_proc_mia
	Left Join Paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda and Dt_Par=dt_cheg_mia and cd_tp_par='OFC'
	Left Join Tipo_Taxa TT on TT.cd_tp_Tx=CTA.cd_tp_Tx
	Left Join Caixa_hou_imp_aer CXA on CTA.num_proc_hia=CXA.num_proc_hia and CTA.cd_Tp_Tx=CXA.cd_tp_Tx and CTA.dc_hia=CXA.dc_hia and num_lcto <> 'PROVISÓRIO'
Where 
	Desp_Org_HIA='N' and apelido like @Cliente and convert(Datetime,dt_cheg_mia,105) between @DataInicial and @DataFinal
	and cta.cd_tp_tx not in ('143','149','135','142','ADT','125')







GO
