SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE pVerCtraPtdas_Sel 
(
@num_proc	VarChar(16),
@old_fat	VarChar(17) ='', 
@StrMachine 	VarChar(50)=''
)
AS
	If left(@Num_Proc, 2) = 'IM'		
			Select ctec.cd_tp_moeda, ctec.vlr_org_him vlr_org_him from cta_cte_hou_imp_mar ctec 
			join tipo_taxa tt on tt.cd_tp_tx = ctec.cd_tp_tx 
			--left join cta_cte_hou_imp_mar cted on cted.num_proc_him = ctec.num_proc_him and cted.cd_tp_tx = ctec.cd_tp_tx and cted.dc_him = 'D'
			--left join cta_cte_mas_imp_mar ctemd on ctemd.num_proc_mim = left(ctec.num_proc_him, 14) and ctemd.cd_tp_tx = ctec.cd_tp_tx and ctemd.dc_mim = 'D'
			where
				ctec.dc_him = 'C' and 
				ctec.num_proc_him = @num_proc and ctec.cpmf_him = 'N' and 
				tt.isent_cpmf = 'X' and ctec.cd_tp_tx not  in 
				(select cd_tp_Tx from item_fat itf join fatura fat on fat.fatcod = itf.fatcod where num_proc = @Num_proc and itf.fatcod <> @old_fat and fatstatus = 1)
				--and (cted.num_proc_him is not null or ctemd.num_proc_mim is not null) 
				and ctec.cd_tp_Tx in (Select TmpCd_Tp_Tx From Tmp_Fatura Where StrMachine = @StrMachine and TmpDC = 'C' and TmpProcesso = @num_proc and TmpVlrOrg - TmpVlrRef >0)


	If left(@Num_Proc, 2) = 'IA'		
			Select ctec.cd_tp_moeda, ctec.vlr_org_HIA vlr_org_him from cta_cte_hou_imp_aer ctec 	
			join tipo_taxa tt on tt.cd_tp_tx = ctec.cd_tp_tx 
			--left join cta_cte_hou_imp_aer cted on cted.num_proc_HIA = ctec.num_proc_HIA and cted.cd_tp_tx = ctec.cd_tp_tx and cted.dc_HIA = 'D'
			--left join cta_cte_mas_imp_aer ctemd on ctemd.num_proc_mia = left(ctec.num_proc_HIA, 14) and ctemd.cd_tp_tx = ctec.cd_tp_tx and ctemd.dc_mia = 'D'
			where
				ctec.dc_HIA = 'C' and 
				ctec.num_proc_HIA = @num_proc and ctec.cpmf_hia = 'N' and 
				tt.isent_cpmf = 'X' and ctec.cd_tp_tx not  in 
				(select cd_tp_Tx from item_fat itf join fatura fat on fat.fatcod = itf.fatcod where num_proc = @Num_proc and itf.fatcod <> @old_fat and fatstatus = 1)
				--and (cted.num_proc_HIA is not null or ctemd.num_proc_mia is not null)
				and ctec.cd_tp_Tx in (Select TmpCd_Tp_Tx From Tmp_Fatura Where StrMachine = @StrMachine and TmpDC = 'C' and TmpProcesso = @num_proc and TmpVlrOrg - TmpVlrRef > 0 )

	If left(@Num_Proc, 2) = 'EM'		
			Select ctec.cd_tp_moeda, ctec.vlr_org_hem vlr_org_him from cta_cte_hou_exp_mar ctec 
			join tipo_taxa tt on tt.cd_tp_tx = ctec.cd_tp_tx 
			--left join cta_cte_hou_exp_mar cted on cted.num_proc_hem = ctec.num_proc_hem and cted.cd_tp_tx = ctec.cd_tp_tx and cted.dc_hem = 'D'
			--left join cta_cte_mas_exp_mar ctemd on ctemd.num_proc_mem = left(ctec.num_proc_hem, 14) and ctemd.cd_tp_tx = ctec.cd_tp_tx and ctemd.dc_mem = 'D'
			where
				ctec.dc_hem = 'C' and 
				ctec.num_proc_hem = @num_proc and ctec.cpmf_hem = 'N' and 
				tt.isent_cpmf = 'X' and ctec.cd_tp_tx not  in 
				(select cd_tp_Tx from item_fat itf join fatura fat on fat.fatcod = itf.fatcod where num_proc = @Num_proc and itf.fatcod <> @old_fat and fatstatus = 1)
				--and (cted.num_proc_hem is not null or ctemd.num_proc_mem is not null)
				and ctec.cd_tp_Tx in (Select TmpCd_Tp_Tx From Tmp_Fatura Where StrMachine = @StrMachine and TmpDC = 'C' and TmpProcesso = @num_proc and TmpVlrOrg - TmpVlrRef >0 )

	If left(@Num_Proc, 2) = 'EA'		
			Select ctec.cd_tp_moeda, ctec.vlr_org_hea vlr_org_him from cta_cte_hou_exp_aer ctec 
			join tipo_taxa tt on tt.cd_tp_tx = ctec.cd_tp_tx 
			--left join cta_cte_hou_exp_aer cted on cted.num_proc_hea = ctec.num_proc_hea and cted.cd_tp_tx = ctec.cd_tp_tx and cted.dc_hea = 'D'
			--left join cta_cte_mas_exp_aer ctemd on ctemd.num_proc_mea = left(ctec.num_proc_hea, 14) and ctemd.cd_tp_tx = ctec.cd_tp_tx and ctemd.dc_mea = 'D'
			where
				ctec.dc_hea = 'C' and 
				ctec.num_proc_hea = @num_proc and ctec.cpmf_hea = 'N' and 
				tt.isent_cpmf = 'X' and ctec.cd_tp_tx not  in 
				(select cd_tp_Tx from item_fat itf join fatura fat on fat.fatcod = itf.fatcod where num_proc = @Num_proc and itf.fatcod <> @old_fat and fatstatus = 1)
				--and (cted.num_proc_hea is not null or ctemd.num_proc_mea is not null)
				and ctec.cd_tp_Tx in (Select TmpCd_Tp_Tx From Tmp_Fatura Where StrMachine = @StrMachine and TmpDC = 'C' and TmpProcesso = @num_proc and TmpVlrOrg - TmpVlrRef > 0 )
GO
