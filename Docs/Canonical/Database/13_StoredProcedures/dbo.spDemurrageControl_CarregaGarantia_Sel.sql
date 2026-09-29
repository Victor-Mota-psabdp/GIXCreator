SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  Procedure [dbo].[spDemurrageControl_CarregaGarantia_Sel]
	@Num_Proc varChar(16),
	@cd_tp_tx varChar(6)

as
	Select 
		Num_lcto, 
		Vlr_Pgto_rcto_hia [Vlr_Pgto_rcto_him], 
		Vlr_Pgto_rcto_hia/Vlr_ref_hia  Par_moeda_him 
	from 
		cta_cte_hou_imp_mar CTA With(nolock) 
	Join vwCxas CXA With(nolock) on CTA.num_proc_him=CXA.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_him=cxa.dc_hia  
	where 
		CTA.cd_tp_tx=@cd_tp_tx 
		and CTA.num_proc_him=@Num_Proc


GO
