SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO















CREATE             function [dbo].[spResultado]
			(@processo Char(16))

returns
	Float
as
	Begin
		Declare @Reais as Float
		Declare @Caixa as Float
		Declare @Cta as float				
		

		Set @Reais=Isnull((
				Select sum(dbo.valor(vlr_org_hia,DC_hia)) from cta_cte_hou_imp_aer CTA
				Where num_proc_hia=@processo and cta.cd_tp_moeda='REL' and
				cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)
				and desp_org_hia='N' and left(cta.cd_tp_Tx,1) <> 'X'
			    ),0)
		Set @Caixa=isnull((
				Select sum(dbo.valor(vlr_pgto_rcto_hia,cxa.dc_hia)) from Caixa_hou_imp_Aer CXA
				JOIN Cta_ctE_hou_imp_aer CTA on CTA.num_proc_hia=CXA.num_proc_hia and CTa.cd_tp_Tx=CXA.cd_tp_Tx and CTA.dc_hia=CXA.dc_hia
				Where cd_tp_moeda <> 'REL' and num_lcto <> 'PROVISÓRIO' and cxa.num_proc_hia=@PROCESSO
				and cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)	 and left(cta.cd_tp_Tx,1) <> 'X'
			),0)
	
		Set @Cta= isnull((
				select sum(dbo.valor(vlr_org_hia*(dbo.fpar_m(dt_ins_hia,Cta.cd_tp_moeda,'OFC')),cta.dc_hia)) from cta_ctE_hou_imp_aer CTA
				LEFT JOIN Caixa_hou_imp_aer CXA on CtA.num_proc_hia=CxA.num_proC_hia and cta.cd_tp_tx=CXA.cd_tp_Tx and CTa.dc_hia=CXA.dc_hia and num_lcto <> 'PROVISÓRIO'
				Where cxa.num_proc_hia is null and cta.cd_tp_moeda <> 'REL' and desp_org_hia='N'
				and cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)	and left(cta.cd_tp_Tx,1) <> 'X'				
				and cta.num_proc_hia=@processo  
			),0)


		Set @Reais=@Reais+Isnull((
				Select sum(dbo.valor(vlr_org_hea,DC_hea)) from cta_cte_hou_exp_aer CTA
				Where num_proc_hea=@processo and cta.cd_tp_moeda='REL' and
				cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)
				and desp_dst_hea='N' and left(cta.cd_tp_Tx,1) <> 'X'
			    ),0)
		Set @Caixa=@Caixa+isnull((
				Select sum(dbo.valor(vlr_pgto_rcto_hea,cxa.dc_hea)) from Caixa_hou_exp_Aer CXA
				JOIN Cta_ctE_hou_exp_aer CTA on CTA.num_proc_hea=CXA.num_proc_hea and CTa.cd_tp_Tx=CXA.cd_tp_Tx and CTA.dc_hea=CXA.dc_hea
				Where cd_tp_moeda <> 'REL' and num_lcto <> 'PROVISÓRIO' and cxa.num_proc_hea=@PROCESSO
				and cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)	and left(cta.cd_tp_Tx,1) <> 'X'
			),0)
	
		Set @Cta= @Cta+isnull((
				select sum(dbo.valor(vlr_org_hea*dbo.fpar_m(dt_ins_hea,cta.cd_tp_moeda,'OFC'),cta.dc_hea)) from cta_ctE_hou_exp_aer CTA
				LEFT JOIN Caixa_hou_exp_aer CXA on CtA.num_proc_hea=CxA.num_proC_hea and cta.cd_tp_tx=CXA.cd_tp_Tx and CTa.dc_hea=CXA.dc_hea and num_lcto <> 'PROVISÓRIO'
				Where cxa.num_proc_hea is null and cta.cd_tp_moeda <> 'REL' and desp_dst_hea='N'
				and cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)					
				and cta.num_proc_hea=@processo and left(cta.cd_tp_Tx,1) <> 'X' 
			),0)

	
		Set @Reais=@Reais+Isnull((
				Select sum(dbo.valor(vlr_org_him,DC_him)) from cta_cte_hou_imp_mar CTA
				Where num_proc_him=@processo and cta.cd_tp_moeda='REL' and
				cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)
				and desp_org_him='N' and left(cta.cd_tp_Tx,1) <> 'X'
			    ),0)
		Set @Caixa=@Caixa+isnull((
				Select sum(dbo.valor(vlr_pgto_rcto_him,cxa.dc_him)) from Caixa_hou_imp_mar CXA
				JOIN Cta_ctE_hou_imp_mar CTA on CTA.num_proc_him=CXA.num_proc_him and CTa.cd_tp_Tx=CXA.cd_tp_Tx and CTA.dc_him=CXA.dc_him
				Where cd_tp_moeda <> 'REL' and num_lcto <> 'PROVISÓRIO' and cxa.num_proc_him=@PROCESSO
				and cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)and left(cta.cd_tp_Tx,1) <> 'X'	
			),0)
	
		Set @Cta= @Cta+isnull((
				select sum(dbo.valor(vlr_org_him*dbo.fpar_m(dt_ins_him,cta.cd_tp_moeda,'OFC'),cta.dc_him)) from cta_ctE_hou_imp_mar CTA
				LEFT JOIN Caixa_hou_imp_mar CXA on CtA.num_proc_him=CxA.num_proC_him and cta.cd_tp_tx=CXA.cd_tp_Tx and CTa.dc_him=CXA.dc_him and num_lcto <> 'PROVISÓRIO'
				Where cxa.num_proc_him is null and cta.cd_tp_moeda <> 'REL' and desp_org_him='N'
				and cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)	and left(cta.cd_tp_Tx,1) <> 'X'				
				and cta.num_proc_him=@processo  
			),0)


		Set @Reais=@Reais+Isnull((
				Select sum(dbo.valor(vlr_org_hem,DC_hem)) from cta_cte_hou_exp_mar CTA
				Where num_proc_hem=@processo and cta.cd_tp_moeda='REL' and
				cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc)
				and desp_dst_hem='N'
			    ),0)
		Set @Caixa=@Caixa+isnull((
				Select sum(dbo.valor(vlr_pgto_rcto_hem,cxa.dc_hem)) from Caixa_hou_exp_mar CXA
				JOIN Cta_ctE_hou_exp_mar CTA on CTA.num_proc_hem=CXA.num_proc_hem and CTa.cd_tp_Tx=CXA.cd_tp_Tx and CTA.dc_hem=CXA.dc_hem
				Where cd_tp_moeda <> 'REL' and num_lcto <> 'PROVISÓRIO' and cxa.num_proc_hem=@PROCESSO
				and cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc) and left(cta.cd_tp_Tx,1) <> 'X'	
			),0)
	
		Set @Cta= @Cta+isnull((
				select sum(dbo.valor(vlr_org_hem*dbo.fpar_m(dt_ins_hem,cta.cd_tp_moeda,'OFC'),cta.dc_hem)) from cta_ctE_hou_exp_mar CTA
				LEFT JOIN Caixa_hou_exp_mar CXA on CtA.num_proc_hem=CxA.num_proC_hem and cta.cd_tp_tx=CXA.cd_tp_Tx and CTa.dc_hem=CXA.dc_hem and num_lcto <> 'PROVISÓRIO'
				Where cxa.num_proc_hem is null and cta.cd_tp_moeda <> 'REL' and desp_dst_hem='N'
				and cta.cd_tp_tx not in (select * from param_aekContabil_taxas_exc) and left(cta.cd_tp_Tx,1) <> 'X'					
				and cta.num_proc_hem=@processo  
			),0)














		Return (@Cta+@Caixa+@Reais)
		








		END
















GO
