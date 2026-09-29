SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spATL_AjusteDataPrevisaoInvoice_Upd]--'IMCSR201204227BRC','2012-07-29'
	@FatCod			varchar(17),	
	@DataPrevisao	datetime
		
as
Begin Transaction

		Begin
			update fatura 
				set fatdtvenc = @DataPrevisao
			where
				(FatCod = @FatCod and fatstatus='1')
		END
	
		BEGIN
			If left(@FatCod,2) = 'IM'
				Begin
					update cta_cte_hou_imp_mar 
					set dt_prev_pgto_him = CONVERT(varchar(10),FAT.fatdtvenc,103)
					from cta_cte_hou_imp_mar CC
						join item_fat ITEM with(nolock) on  ITEM.Num_Proc = CC.num_proc_him and ITEM.cd_tp_tx = CC.cd_tp_tx  and ITEM.DC = CC.dc_him
						join Fatura FAT with(nolock) on  ITEM.FatCod = FAT.FatCod 
					where 
						(FAT.FatCod  = @FatCod  and fatstatus='1')			
				End

			If left(@FatCod,2) = 'IA'
				Begin
					update cta_cte_hou_imp_aer 
					set dt_prev_pgto_hia = CONVERT(varchar(10),FAT.fatdtvenc,103)
					from cta_cte_hou_imp_aer CC
						join item_fat ITEM with(nolock) on  ITEM.Num_Proc = CC.num_proc_hia and ITEM.cd_tp_tx = CC.cd_tp_tx  and ITEM.DC = CC.dc_hia
						join Fatura FAT with(nolock) on  ITEM.FatCod = FAT.FatCod 
					where 
						(FAT.FatCod  = @FatCod and fatstatus='1')			
				End

			If left(@FatCod,2) = 'IO'
				Begin
					update cta_cte_hou_imp_out
					set dt_prev_pgto_hio = CONVERT(varchar(10),FAT.fatdtvenc,103)
					from cta_cte_hou_imp_out CC
						join item_fat ITEM with(nolock) on  ITEM.Num_Proc = CC.num_proc_hio and ITEM.cd_tp_tx = CC.cd_tp_tx  and ITEM.DC = CC.dc_hio
						join Fatura FAT with(nolock) on  ITEM.FatCod = FAT.FatCod 
					where 
						(FAT.FatCod  = @FatCod and fatstatus='1')			
				End

			If left(@FatCod,2) = 'EM'
				Begin
					update cta_cte_hou_exp_mar 
					set dt_prev_pgto_hem = CONVERT(varchar(10),FAT.fatdtvenc,103) 
					from cta_cte_hou_exp_mar CC
						join item_fat ITEM with(nolock) on  ITEM.Num_Proc = CC.num_proc_hem and ITEM.cd_tp_tx = CC.cd_tp_tx  and ITEM.DC = CC.dc_hem
						join Fatura FAT with(nolock) on  ITEM.FatCod = FAT.FatCod 
					where 
						(FAT.FatCod  = @FatCod and fatstatus='1')			
				End

			If left(@FatCod,2) = 'EA'
				Begin
					update cta_cte_hou_exp_aer 
					set dt_prev_pgto_hea = CONVERT(varchar(10),FAT.fatdtvenc,103) 
					from cta_cte_hou_exp_aer CC
						join item_fat ITEM with(nolock) on  ITEM.Num_Proc = CC.num_proc_hea and ITEM.cd_tp_tx = CC.cd_tp_tx  and ITEM.DC = CC.dc_hea
						join Fatura FAT with(nolock) on  ITEM.FatCod = FAT.FatCod 
					where 
						(FAT.FatCod  = @FatCod and fatstatus='1')			
				End

			If left(@FatCod,2) = 'EO'
				Begin
					update cta_cte_hou_exp_out 
					set dt_prev_pgto_heo = CONVERT(varchar(10),FAT.fatdtvenc,103) 
					from cta_cte_hou_exp_out CC
						join item_fat ITEM with(nolock) on  ITEM.Num_Proc = CC.num_proc_heo and ITEM.cd_tp_tx = CC.cd_tp_tx  and ITEM.DC = CC.dc_heo
						join Fatura FAT with(nolock) on  ITEM.FatCod = FAT.FatCod 
					where 
						(FAT.FatCod  = @FatCod and fatstatus='1')			
				End
		END

	IF @@ERROR <> 0
		BEGIN
			RETURN -1
		END
COMMIT TRANSACTION
GO
