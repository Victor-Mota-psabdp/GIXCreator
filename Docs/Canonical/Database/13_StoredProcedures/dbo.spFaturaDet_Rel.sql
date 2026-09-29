SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE        Procedure spFaturaDet_Rel 

		@processo	varchar(16)
		
AS

Select
	Nome_Tp_Tx,CTA.cd_tp_moeda Moeda,
	cast(dbo.valor(Vlr_org_hea,CTA.DC_HEA) as smallmoney) Valor,cast(Par_Moeda as money)  Par_Moeda,cast(cast(dbo.valor(Vlr_org_hea,CTA.DC_HEA) as smallmoney)*cast(Par_moeda as money) as money) as TOTAL 
From
	Cta_cte_hou_exp_aer CTA
	Join tipo_taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Outer Join caixa_hou_exp_aer CXA on CTA.num_proc_hea=CXA.num_proc_hea and CTA.cd_tp_tx=CXA.cd_tp_tx and CTA.dc_hea=CXA.dc_hea
	Join house_exp_aer HOU on HOU.num_proc_hea=CTA.num_proc_hea
	Left Outer Join paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda and PAR.cd_tp_par='EXA' and dt_par=HOU.dt_rcb_Doc_hea
where 
	desp_dst_hea='N' and Comp_RP_HEA='S' and
	CXA.num_proc_hea is null and CTA.num_proc_hea=@processo
	and cd_cred_dev_hea=cd_export_hea









GO
