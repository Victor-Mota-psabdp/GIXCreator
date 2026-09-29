SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spDemD_Chk]
		@Fatura	Char(17)
as
	Select 
		CTA.Num_Nf_him,cxa.num_lcto
	from item_Fat itf
		Join cta_cte_hou_imp_mar CTA on CTA.NUM_proc_him=ITF.NUM_PROC AND ITF.CD_TP_TX=CTA.CD_TP_TX AND ITF.DC=CTA.DC_HIM
		Left Join Caixa_hou_imp_mar CXA on CTA.num_proc_him=CXA.num_proc_him and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_him=cxa.dc_him
	Where 
	itf.fatcod=@Fatura
GO
