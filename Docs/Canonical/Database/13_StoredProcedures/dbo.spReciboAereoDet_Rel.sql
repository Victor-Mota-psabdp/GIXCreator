SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spReciboAereoDet_Rel]--'EAATL201208004BR','LA2013020031'
	@Processo as varchar(16),
	@Num_Lcto as varchar(12)
as

If Left(@Processo,2) = 'EA'
	Begin
		select CX.Num_proc_hea Processo, TT.nome_tp_tx Taxa, CX.DC_hea DC, CC.cd_tp_moeda,Vlr_Ref_hea Vlr_Ref, Par_Moeda_hea Par_Moeda, Vlr_Pgto_Rcto_hea Vlr_Pgto_Rcto from caixa_hou_exp_aer CX
		left outer join tipo_taxa TT on CX.cd_tp_tx = tt.cd_tp_tx
		left outer join cta_cte_hou_exp_aer CC on CX.Num_Proc_hea = CC.Num_Proc_hea and CX.cd_tp_tx = CC.cd_tp_tx and CX.DC_hea = CC.Dc_hea
		where CX.num_proc_hea = @Processo and CX.num_lcto = @Num_Lcto
	End
Else 
	If left(@Processo,2) = 'IA'
	Begin
		select CX.Num_proc_hia Processo, TT.nome_tp_tx Taxa, CX.DC_hia DC, CC.cd_tp_moeda,Vlr_Ref_hia Vlr_Ref, Par_Moeda_hia Par_Moeda, Vlr_Pgto_Rcto_hia Vlr_Pgto_Rcto from caixa_hou_imp_aer CX
		left outer join tipo_taxa TT on CX.cd_tp_tx = tt.cd_tp_tx
		left outer join cta_cte_hou_imp_aer CC on CX.Num_Proc_hia = CC.Num_Proc_hia and CX.cd_tp_tx = CC.cd_tp_tx and CX.DC_hia = CC.Dc_hia
		where CX.num_proc_hia = @Processo and CX.num_lcto = @Num_Lcto
	End
		
GO
