SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE pFatCanc_Upd 
(
@FatCod	VarChar(17)
)
AS
	Declare @Num_Proc	VarChar(17) 
	Declare @Cd_tp_Tx	Char(3) 
	Begin Transaction 
	Declare CurFat Cursor For 
	Select Num_Proc, Cd_Tp_Tx From Item_Fat Where FatCod = @FatCod and Cd_Tp_Tx like 'C$%'
	
	Open CurFat 
	Fetch Next From CurFat into @Num_Proc, @Cd_TP_Tx 
	While @@Fetch_Status =0 
		Begin 
			if left(@Num_Proc, 2) = 'EA' 
				Delete from cta_cte_hou_exp_aer where Num_proc_hea = @Num_Proc and DC_HEA = 'C' and Cd_Tp_Tx = @Cd_Tp_Tx   
			if left(@Num_Proc, 2) = 'EM' 
				Delete from cta_cte_hou_exp_mar where Num_proc_hem = @Num_Proc and DC_HEM = 'C' and Cd_Tp_Tx = @Cd_Tp_Tx   
			if left(@Num_Proc, 2) = 'IA' 
				Delete from cta_cte_hou_imp_aer where Num_proc_hia = @Num_Proc and DC_HIA = 'C' and Cd_Tp_Tx = @Cd_Tp_Tx   
			if left(@Num_Proc, 2) = 'IM' 
				Delete from cta_cte_hou_imp_mar where Num_proc_him = @Num_Proc and DC_HIM = 'C' and Cd_Tp_Tx = @Cd_Tp_Tx   

			if @@Error <> 0 
				Begin 
					Rollback Transaction 
					Return -1 
				End 
			Fetch Next From CurFat into @Num_Proc, @Cd_TP_Tx 
		End 
	Close CurFat 
	Deallocate CurFat 
	
	Update Fatura Set FatStatus = 0 Where FatCod = @FatCod 
	If @@Error <> 0 
		Begin 
			Rollback Transaction 
			Return -2 
		End
	else 
		Begin 
			Commit Transaction 
			Return 1
		End
GO
