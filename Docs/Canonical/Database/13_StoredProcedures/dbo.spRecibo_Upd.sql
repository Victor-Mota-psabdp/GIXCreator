SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE procedure [dbo].[spRecibo_Upd] --'LB2008060226','EMCSR20080212101','DOW BRASIL S 05031A1'
	@Num_Lcto as varchar(12),
	@Processo as varchar(16),
	@Cred_Dev as varchar (50)
as

	Declare @Cd_Cred_Dev as varchar(10)
	Declare @Num_Recibo as varchar(12)
	
	Set @Cd_Cred_Dev = (Select cd_pes from pessoa where apelido = @Cred_Dev)
	
	Set @Num_Recibo = (select isnull(max(right(Num_Rcb_HIA,5)),0)+1 NR  from vwcxas where  left(Num_rcb_hia,2) = 'RC' and right(left(Num_rcb_hia,5),2) = right(year(getdate()),2) and right(left(Num_rcb_hia,7),2) = month(getdate()))
	Set @Num_Recibo = 'RCA' + cast(right(year(getdate()),2)as varchar(2)) +  right('00' + cast(month(getdate())as varchar(2)),2) + cast(right('00000' + @Num_Recibo,5)as varchar(5))

Begin Transaction
If len(@Processo) = 16 or substring(@Processo,3,3) = 'REM'
	Begin
		If left(@Processo,2) = 'EM' 
			Begin
				update caixa_hou_exp_mar  set num_rcb_hem = @Num_Recibo from caixa_hou_exp_mar CX
				join cta_cte_hou_exp_mar CC on CX.num_proc_hem = CC.num_proc_hem and CX.cd_tp_tx = CC.cd_tp_tx and CX.dc_hem = CC.dc_hem
				where CX.num_lcto = @Num_Lcto and CX.num_proc_hem = @Processo  and CC.cd_cred_dev_hem = @cd_cred_dev-- and (CX.num_rcb_hem is null or CX.num_rcb_hem = '')
			End
		Else If left(@Processo,2) = 'IM'
			Begin
				update caixa_hou_imp_mar set num_rcb_him = @Num_Recibo from caixa_hou_imp_mar CX
				join cta_cte_hou_imp_mar CC on CX.num_proc_him = CC.num_proc_him and CX.cd_tp_tx = CC.cd_tp_tx and CX.dc_him = CC.dc_him
				where CX.num_lcto = @Num_Lcto and CX.num_proc_him = @Processo and CC.cd_cred_dev_him = @cd_cred_dev --and (CX.num_rcb_him is null or CX.num_rcb_him = '')
			End
		Else If Left(@Processo,2) = 'EA'
			Begin
				update caixa_hou_exp_aer set num_rcb_hea = @Num_Recibo from caixa_hou_exp_aer CX
				join cta_cte_hou_exp_aer CC on CX.num_proc_hea = CC.num_proc_hea and CX.cd_tp_tx = CC.cd_tp_tx and CX.dc_hea = CC.dc_hea
				where CX.num_lcto = @Num_Lcto and CX.num_proc_hea = @Processo  and CC.cd_cred_dev_hea = @cd_cred_dev --and (CX.num_rcb_hea is null or CX.num_rcb_hea = '')
			End
		Else If left(@Processo,2) = 'IA'
			Begin
				update caixa_hou_imp_aer set num_rcb_hia = @Num_Recibo from caixa_hou_imp_aer CX
				join cta_cte_hou_imp_aer CC on CX.num_proc_hia = CC.num_proc_hia and CX.cd_tp_tx = CC.cd_tp_tx and CX.dc_hia = CC.dc_hia
				where CX.num_lcto = @Num_Lcto and CX.num_proc_hia = @Processo  and CC.cd_cred_dev_hia = @cd_cred_dev --and (CX.num_rcb_hia is null or CX.num_rcb_hia = '')
			End
		Else If left(@Processo,2) = 'EO'
			Begin
				update caixa_hou_exp_out set num_rcb_heo = @Num_Recibo from caixa_hou_exp_out CX
				join cta_cte_hou_exp_out CC on CX.num_proc_heo = CC.num_proc_heo and CX.cd_tp_tx = CC.cd_tp_tx and CX.dc_heo = CC.dc_heo
				where CX.num_lcto = @Num_Lcto and CX.num_proc_heo = @Processo  and CC.cd_cred_dev_heo = @cd_cred_dev --and (CX.num_rcb_heo is null or CX.num_rcb_heo = '')
			End
		Else If left(@Processo,2) = 'IO'
			Begin
				update caixa_hou_imp_out set num_rcb_hio = @Num_Recibo from caixa_hou_imp_out CX
				join cta_cte_hou_imp_out CC on CX.num_proc_hio = CC.num_proc_hio and CX.cd_tp_tx = CC.cd_tp_tx and CX.dc_hio = CC.dc_hio
				where CX.num_lcto = @Num_Lcto and CX.num_proc_hio = @Processo  and CC.cd_cred_dev_hio = @cd_cred_dev --and (CX.num_rcb_hio is null or CX.num_rcb_hio = '')
			End
End
If len(@Processo) = 14
	Begin
		If left(@Processo,2) = 'EM'
			Begin
				update caixa_mas_exp_mar set num_rcb_mem = @Num_Recibo from caixa_mas_exp_mar CX
				join cta_cte_mas_exp_mar CC on CX.num_proc_mem = CC.num_proc_mem and CX.cd_tp_tx = CC.cd_tp_tx and CX.dc_mem = CC.dc_mem
				where CX.num_lcto = @Num_Lcto and CX.num_proc_mem = @Processo  and CC.cd_cred_dev_mem = @cd_cred_dev --and (CX.num_rcb_mem is null or CX.num_rcb_mem = '')
			End	
		Else If left(@Processo,2) = 'IM'
			Begin
				update caixa_mas_imp_mar set num_rcb_mim = @Num_Recibo from caixa_mas_imp_mar CX
				join cta_cte_mas_imp_mar CC on CX.num_proc_mim = CC.num_proc_mim and CX.cd_tp_tx = CC.cd_tp_tx and CX.dc_mim = CC.dc_mim
				where CX.num_lcto = @Num_Lcto and CX.num_proc_mim = @Processo  and CC.cd_cred_dev_mim = @cd_cred_dev --and (CX.num_rcb_mim is null or CX.num_rcb_mim = '')
			End
		Else If left(@Processo,2) = 'EA'
			Begin
				update caixa_mas_exp_aer set num_rcb_mea = @Num_Recibo from caixa_mas_exp_aer CX
				join cta_cte_mas_exp_aer CC on CX.num_proc_mea = CC.num_proc_mea and CX.cd_tp_tx = CC.cd_tp_tx and CX.dc_mea = CC.dc_mea
				where CX.num_lcto = @Num_Lcto and CX.num_proc_mea = @Processo  and CC.cd_cred_dev_mea = @cd_cred_dev --and (CX.num_rcb_mea is null or CX.num_rcb_mea = '')
			End
		Else If Left(@Processo,2) = 'IA'
			Begin
				update caixa_mas_imp_aer set num_rcb_mia = @Num_Recibo from caixa_mas_imp_aer CX
				join cta_cte_mas_imp_aer CC on CX.num_proc_mia = CC.num_proc_mia and CX.cd_tp_tx = CC.cd_tp_tx and CX.dc_mia = CC.dc_mia
				where CX.num_lcto = @Num_Lcto and CX.num_proc_mia = @Processo  and CC.cd_cred_dev_mia = @cd_cred_dev --and (CX.num_rcb_mia is null or CX.num_rcb_mia = '')
			End
END
	if @@Error<>0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END
COMMIT TRANSACTION


GO
