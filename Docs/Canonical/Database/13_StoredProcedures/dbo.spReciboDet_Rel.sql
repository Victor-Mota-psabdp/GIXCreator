SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE procedure [dbo].[spReciboDet_Rel] --'EMCSR20080210601','LA2009060004'
	@Processo as varchar(16),
	@Num_Lcto as varchar(12)
as

If len(@Processo) = 16 or substring(@Processo,3,3) = 'REM'
	Begin
		If left(@Processo,2) = 'EM' 
			Begin
				select CX.Num_proc_hem Processo, TT.nome_tp_tx Taxa, CX.DC_HEM DC, CC.cd_tp_moeda,Vlr_Ref_hem Vlr_Ref, Par_Moeda_hem Par_Moeda, Vlr_Pgto_Rcto_Hem Vlr_Pgto_Rcto from caixa_hou_exp_mar CX
				left outer join tipo_taxa TT on CX.cd_tp_tx = tt.cd_tp_tx
				left outer join cta_cte_hou_exp_mar CC on CX.Num_Proc_hem = CC.Num_Proc_hem and CX.cd_tp_tx = CC.cd_tp_tx and CX.DC_Hem = CC.Dc_Hem
				where CX.num_proc_hem = @Processo and CX.num_lcto = @Num_Lcto
			End
		Else If left(@Processo,2) = 'IM'
			Begin
				select CX.Num_proc_him Processo, TT.nome_tp_tx Taxa, CX.DC_him DC, CC.cd_tp_moeda,Vlr_Ref_him Vlr_Ref, Par_Moeda_him Par_Moeda, Vlr_Pgto_Rcto_him Vlr_Pgto_Rcto from caixa_hou_imp_mar CX
				left outer join tipo_taxa TT on CX.cd_tp_tx = tt.cd_tp_tx
				left outer join cta_cte_hou_imp_mar CC on CX.Num_Proc_him = CC.Num_Proc_him and CX.cd_tp_tx = CC.cd_tp_tx and CX.DC_him = CC.Dc_him
				where CX.num_proc_him = @Processo and CX.num_lcto = @Num_Lcto and CC.cD_tp_tx <> 'XCA'
			End
		Else If Left(@Processo,2) = 'EA'
			Begin
				select CX.Num_proc_hea Processo, TT.nome_tp_tx Taxa, CX.DC_hea DC, CC.cd_tp_moeda,Vlr_Ref_hea Vlr_Ref, Par_Moeda_hea Par_Moeda, Vlr_Pgto_Rcto_hea Vlr_Pgto_Rcto from caixa_hou_exp_aer CX
				left outer join tipo_taxa TT on CX.cd_tp_tx = tt.cd_tp_tx
				left outer join cta_cte_hou_exp_aer CC on CX.Num_Proc_hea = CC.Num_Proc_hea and CX.cd_tp_tx = CC.cd_tp_tx and CX.DC_hea = CC.Dc_hea
				where CX.num_proc_hea = @Processo and CX.num_lcto = @Num_Lcto
			End
		Else If left(@Processo,2) = 'IA'
			Begin
				select CX.Num_proc_hia Processo, TT.nome_tp_tx Taxa, CX.DC_hia DC, CC.cd_tp_moeda,Vlr_Ref_hia Vlr_Ref, Par_Moeda_hia Par_Moeda, Vlr_Pgto_Rcto_hia Vlr_Pgto_Rcto from caixa_hou_imp_aer CX
				left outer join tipo_taxa TT on CX.cd_tp_tx = tt.cd_tp_tx
				left outer join cta_cte_hou_imp_aer CC on CX.Num_Proc_hia = CC.Num_Proc_hia and CX.cd_tp_tx = CC.cd_tp_tx and CX.DC_hia = CC.Dc_hia
				where CX.num_proc_hia = @Processo and CX.num_lcto = @Num_Lcto
			End
		Else If left(@Processo,2) = 'EO'
			Begin
				select CX.Num_proc_heo Processo, TT.nome_tp_tx Taxa, CX.DC_heo DC, CC.cd_tp_moeda,Vlr_Ref_heo Vlr_Ref, Par_Moeda_heo Par_Moeda, Vlr_Pgto_Rcto_heo Vlr_Pgto_Rcto from caixa_hou_exp_out CX
				left outer join tipo_taxa TT on CX.cd_tp_tx = tt.cd_tp_tx
				left outer join cta_cte_hou_exp_out CC on CX.Num_Proc_heo = CC.Num_Proc_heo and CX.cd_tp_tx = CC.cd_tp_tx and CX.DC_heo = CC.Dc_heo
				where CX.num_proc_heo = @Processo and CX.num_lcto = @Num_Lcto
			End
		Else If left(@Processo,2) = 'IO'
			Begin
				select CX.Num_proc_hio Processo, TT.nome_tp_tx Taxa, CX.DC_hio DC, CC.cd_tp_moeda,Vlr_Ref_hio Vlr_Ref, Par_Moeda_hio Par_Moeda, Vlr_Pgto_Rcto_hio Vlr_Pgto_Rcto from caixa_hou_imp_out CX
				left outer join tipo_taxa TT on CX.cd_tp_tx = tt.cd_tp_tx
				left outer join cta_cte_hou_imp_out CC on CX.Num_Proc_hio = CC.Num_Proc_hio and CX.cd_tp_tx = CC.cd_tp_tx and CX.DC_hio = CC.Dc_hio
				where CX.num_proc_hio = @Processo and CX.num_lcto = @Num_Lcto
			End
end
If len(@Processo) = 14
	Begin
		If left(@Processo,2) = 'EM'
			Begin
				select CX.Num_proc_mem Processo, TT.nome_tp_tx Taxa, CX.DC_mem DC, CC.cd_tp_moeda,Vlr_Ref_mem Vlr_Ref, Par_Moeda_mem Par_Moeda, Vlr_Pgto_Rcto_mem Vlr_Pgto_Rcto from caixa_mas_exp_mar CX
				left outer join tipo_taxa TT on CX.cd_tp_tx = tt.cd_tp_tx
				left outer join cta_cte_mas_exp_mar CC on CX.Num_Proc_mem = CC.Num_Proc_mem and CX.cd_tp_tx = CC.cd_tp_tx and CX.DC_mem = CC.Dc_mem
				where CX.num_proc_mem = @Processo and CX.num_lcto = @Num_Lcto
			End	
		Else If left(@Processo,2) = 'IM'
			Begin
				select CX.Num_proc_mim Processo, TT.nome_tp_tx Taxa, CX.DC_mim DC, CC.cd_tp_moeda,Vlr_Ref_mim Vlr_Ref, Par_Moeda_mim Par_Moeda, Vlr_Pgto_Rcto_mim Vlr_Pgto_Rcto from caixa_mas_imp_mar CX
				left outer join tipo_taxa TT on CX.cd_tp_tx = tt.cd_tp_tx
				left outer join cta_cte_mas_imp_mar CC on CX.Num_Proc_mim = CC.Num_Proc_mim and CX.cd_tp_tx = CC.cd_tp_tx and CX.DC_mim = CC.Dc_mim
				where CX.num_proc_mim = @Processo and CX.num_lcto = @Num_Lcto
			End
		Else If left(@Processo,2) = 'EA'
			Begin
				select CX.Num_proc_mea Processo, TT.nome_tp_tx Taxa, CX.DC_mea DC, CC.cd_tp_moeda,Vlr_Ref_mea Vlr_Ref, Par_Moeda_mea Par_Moeda, Vlr_Pgto_Rcto_mea Vlr_Pgto_Rcto from caixa_mas_exp_aer CX
				left outer join tipo_taxa TT on CX.cd_tp_tx = tt.cd_tp_tx
				left outer join cta_cte_mas_exp_aer CC on CX.Num_Proc_mea = CC.Num_Proc_mea and CX.cd_tp_tx = CC.cd_tp_tx and CX.DC_mea = CC.Dc_mea
				where CX.num_proc_mea = @Processo and CX.num_lcto = @Num_Lcto
			End
		Else If Left(@Processo,2) = 'IA'
			Begin
				select CX.Num_proc_mia Processo, TT.nome_tp_tx Taxa, CX.DC_mia DC, CC.cd_tp_moeda,Vlr_Ref_mia Vlr_Ref, Par_Moeda_mia Par_Moeda, Vlr_Pgto_Rcto_mia Vlr_Pgto_Rcto from caixa_mas_imp_aer CX
				left outer join tipo_taxa TT on CX.cd_tp_tx = tt.cd_tp_tx
				left outer join cta_cte_mas_imp_aer CC on CX.Num_Proc_mia = CC.Num_Proc_mia and CX.cd_tp_tx = CC.cd_tp_tx and CX.DC_mia = CC.Dc_mia
				where CX.num_proc_mia = @Processo and CX.num_lcto = @Num_Lcto
			End
END




GO
