SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spFretesARemeter_Rel] --'%','%'

		@Modal		Varchar(20),
		@Apelido	Varchar(50)

AS

if @Modal='Air' 
	Begin

			select  hou.num_proc_hia Job_Number, Nome_Local Destino,Dt_Cheg_mia Dt_Chegada,PP.Apelido Agent,cta.cd_tp_moeda Moeda,CTA.Vlr_org_hia Valor,HAWB_HIA House,MAWB_HIA Master,Isnull(CXO.Num_Lcto,'N') Recebido, Isnull(REM.Num_LCto,'D') Num_Lcto,cxo.vlr_pgto_rcto_hia ValorPg from cta_cte_hou_imp_aer CTA
			Left Join Caixa_Hou_Imp_aer CXA on CTA.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia and CXA.Num_Lcto <> 'PROVISÓRIO'
			Join Pessoa PP on PP.cd_pes=cd_cred_dev_hia 
			Join House_Imp_Aer Hou on hou.num_proc_hia=cta.num_proc_hia
			Left Join Caixa_Hou_Imp_Aer CXO on CTA.num_proC_hia=cxo.num_proc_hia and cta.cd_tp_tx=cxo.cd_tp_tx and cta.dc_hia<>cxo.dc_hia
			Join MAster_Imp_Aer MAS on MAS.num_proc_mia=hou.num_proc_mia
			Join Localidade DST on DST.cd_local=cd_dst_hia
			Left Join Caixa_Hou_Imp_AEr REM on CTA.num_proc_hia=REM.num_proc_hia and cta.cd_tp_tx=REM.cd_tp_tx and cta.dc_hia=REM.dc_hia and REM.Num_Lcto = 'PROVISÓRIO'

			Where
				cxa.num_lcto is null and cta.cd_tp_tx='FRT' and cta.dc_hia='D' and desp_org_hia='N'
				and mas.num_proc_mia <> 'JOB'
				AND CONVERT(DATETIME,dt_cheg_mia,105) <=GETDATE()
	End

if @modal='Ocean'
	Begin

			select  hou.num_proc_him Job_Number, Nome_Local Destino,Dt_atrac_mim Dt_Chegada,PP.Apelido Agent,cta.cd_tp_moeda Moeda,CTA.Vlr_org_him Valor,HAWB_HIM House,MAWB_HIM Master,Isnull(CXO.Num_Lcto,'N') Recebido, Isnull(REM.Num_LCto,'D') Num_Lcto, cxo.vlr_pgto_rcto_him ValorPg from cta_cte_hou_imp_mar CTA
			Left Join Caixa_Hou_Imp_Mar CXA on CTA.num_proc_him=cxa.num_proc_him and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_him=cxa.dc_him and CXA.Num_Lcto <> 'PROVISÓRIO'
			Join Pessoa PP on PP.cd_pes=cd_cred_dev_him 
			Join House_Imp_Mar Hou on hou.num_proc_him=cta.num_proc_him
			Left Join Caixa_Hou_Imp_Mar CXO on CTA.num_proC_him=cxo.num_proc_him and cta.cd_tp_tx=cxo.cd_tp_tx and cta.dc_him<>cxo.dc_him
			Join MAster_Imp_mar MAS on MAS.num_proc_mim=hou.num_proc_mim
			Join Localidade DST on DST.cd_local=cd_dst_him
			Left Join Caixa_Hou_Imp_Mar REM on CTA.num_proc_him=REM.num_proc_him and cta.cd_tp_tx=REM.cd_tp_tx and cta.dc_him=REM.dc_him and REM.Num_Lcto = 'PROVISÓRIO'

			Where
				cxa.num_lcto is null and cta.cd_tp_tx='FRT' and cta.dc_him='D' and desp_org_him='N'
				and mas.num_proc_mim <> 'JOB'
				AND CONVERT(DATETIME,DT_ATRAC_MIM,105) <=GETDATE()
	End

if @modal='%' 
	Begin
			select  hou.num_proc_hia Job_Number, Nome_Local Destino,Dt_Cheg_mia Dt_Chegada,PP.Apelido Agent,cta.cd_tp_moeda Moeda,CTA.Vlr_org_hia Valor,HAWB_HIA House,MAWB_HIA Master,Isnull(CXO.Num_Lcto,'N') Recebido, Isnull(REM.Num_LCto,'D') Num_Lcto,cxo.vlr_pgto_rcto_hia ValorPg from cta_cte_hou_imp_aer CTA
			Left Join Caixa_Hou_Imp_aer CXA on CTA.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia and CXA.Num_Lcto <> 'PROVISÓRIO'
			Join Pessoa PP on PP.cd_pes=cd_cred_dev_hia 
			Join House_Imp_Aer Hou on hou.num_proc_hia=cta.num_proc_hia
			Left Join Caixa_Hou_Imp_Aer CXO on CTA.num_proC_hia=cxo.num_proc_hia and cta.cd_tp_tx=cxo.cd_tp_tx and cta.dc_hia<>cxo.dc_hia
			Join MAster_Imp_Aer MAS on MAS.num_proc_mia=hou.num_proc_mia
			Join Localidade DST on DST.cd_local=cd_dst_hia
			Left Join Caixa_Hou_Imp_AEr REM on CTA.num_proc_hia=REM.num_proc_hia and cta.cd_tp_tx=REM.cd_tp_tx and cta.dc_hia=REM.dc_hia and REM.Num_Lcto = 'PROVISÓRIO'

			Where
				cxa.num_lcto is null and cta.cd_tp_tx='FRT' and cta.dc_hia='D' and desp_org_hia='N'
				and mas.num_proc_mia <> 'JOB'
				AND CONVERT(DATETIME,dt_cheg_mia,105) <=GETDATE()

			UNION

			select  hou.num_proc_him Job_Number, Nome_Local Destino,Dt_atrac_mim Dt_Chegada,PP.Apelido Agent,cta.cd_tp_moeda Moeda,CTA.Vlr_org_him Valor,HAWB_HIM House,MAWB_HIM Master,Isnull(CXO.Num_Lcto,'N') Recebido, Isnull(REM.Num_LCto,'D') Num_Lcto, cxo.vlr_pgto_rcto_him ValorPg from cta_cte_hou_imp_mar CTA
			Left Join Caixa_Hou_Imp_Mar CXA on CTA.num_proc_him=cxa.num_proc_him and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_him=cxa.dc_him and CXA.Num_Lcto <> 'PROVISÓRIO'
			Join Pessoa PP on PP.cd_pes=cd_cred_dev_him 
			Join House_Imp_Mar Hou on hou.num_proc_him=cta.num_proc_him
			Left Join Caixa_Hou_Imp_Mar CXO on CTA.num_proC_him=cxo.num_proc_him and cta.cd_tp_tx=cxo.cd_tp_tx and cta.dc_him<>cxo.dc_him
			Join MAster_Imp_mar MAS on MAS.num_proc_mim=hou.num_proc_mim
			Join Localidade DST on DST.cd_local=cd_dst_him
			Left Join Caixa_Hou_Imp_Mar REM on CTA.num_proc_him=REM.num_proc_him and cta.cd_tp_tx=REM.cd_tp_tx and cta.dc_him=REM.dc_him and REM.Num_Lcto = 'PROVISÓRIO'

			Where
				cxa.num_lcto is null and cta.cd_tp_tx='FRT' and cta.dc_him='D' and desp_org_him='N'
				and mas.num_proc_mim <> 'JOB'
				AND CONVERT(DATETIME,DT_ATRAC_MIM,105) <=GETDATE()
	END 

GO
