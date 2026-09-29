SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[spLogCaixa_Ins] -- 'Administrador', 'E', 'EMCSR20080400401', select * from tipo_taxa where nome_tp_tx = 'CSLL (01) (1,00%)', 'D', 'LA2008072562'

	@Usuario	varchar(50),
	@Tp_Oper	char(1),	
	@Num_proc	varchar(16),
	@Tp_Tx		varchar(50),
	@DC			char(1),	
	@Num_Lcto	varchar(12)

as

	Declare @Cd_Tp_Tx as char(3)
	Declare @Cd_Usuario as varchar(10)
	if len(@Tp_tx)=3
		Begin
			Set @cd_tp_tx=@tp_tx
		end
	ELSE
		Begin
			Set @Cd_Tp_Tx = (Select cd_tp_tx from tipo_taxa where nome_tp_tx = @TP_Tx)
		End
	Set @CD_Usuario = (Select cd_usuario from usuario where nome_usuario = @usuario)


Begin Transaction

if len(@Num_proc) = 16
	Begin
		if left(@Num_proc,2) = 'EM'
			Begin
				insert into
					Log_Caixa (
								Data_Cx,
								Cd_Usuario,
								Tp_Oper_Cx,
								Num_Proc_Cx,
								Cd_Tp_Tx,
								DC_Cx,
								Num_Lcto_Cx,
								Vlr_Ref,
								Dt_Conv,
								Cd_Tp_Par,
								Par_Moeda_Cx,
								Vlr_Pgto_Rcto,
								Dt_Pgto_Rcto_Cx,
								Num_Rcb
							)
					(
					Select
							getdate(),
							@Cd_Usuario,
							@Tp_Oper,
							@Num_proc,
							@Cd_Tp_Tx,
							@DC,
							@Num_Lcto,
							Vlr_Ref_hem,
							Dt_Conv_hem,
							Cd_Tp_Par,
							Par_Moeda_HEM,
							Vlr_Pgto_Rcto_HEM,
							Dt_Pgto_Rcto_HEM,
							Num_Rcb_HEM
					from
							caixa_hou_exp_mar
					where 
							num_proc_hem = @Num_proc and cd_tp_tx = @cd_tp_tx and dc_hem = @DC and num_lcto = @Num_lcto
					)
			End
		if left(@Num_proc,2) = 'IM'
			Begin
				insert into
					Log_Caixa (
								Data_Cx,
								Cd_Usuario,
								Tp_Oper_Cx,
								Num_Proc_Cx,
								Cd_Tp_Tx,
								DC_Cx,
								Num_Lcto_Cx,
								Vlr_Ref,
								Dt_Conv,
								Cd_Tp_Par,
								Par_Moeda_Cx,
								Vlr_Pgto_Rcto,
								Dt_Pgto_Rcto_Cx,
								Num_Rcb
							)
					(
					Select
							getdate(),
							@Cd_Usuario,
							@Tp_Oper,
							@Num_proc,
							@Cd_Tp_Tx,
							@DC,
							@Num_Lcto,
							Vlr_Ref_him,
							Dt_Conv_him,
							Cd_Tp_Par,
							Par_Moeda_him,
							Vlr_Pgto_Rcto_him,
							Dt_Pgto_Rcto_him,
							Num_Rcb_him
					from
							caixa_hou_imp_mar
					where 
							num_proc_him = @Num_proc and cd_tp_tx = @cd_tp_tx and dc_him = @DC and num_lcto = @Num_lcto
					)
			End

		if left(@Num_proc,2) = 'EA'
			Begin
				insert into
					Log_Caixa (
								Data_Cx,
								Cd_Usuario,
								Tp_Oper_Cx,
								Num_Proc_Cx,
								Cd_Tp_Tx,
								DC_Cx,
								Num_Lcto_Cx,
								Vlr_Ref,
								Dt_Conv,
								Cd_Tp_Par,
								Par_Moeda_Cx,
								Vlr_Pgto_Rcto,
								Dt_Pgto_Rcto_Cx,
								Num_Rcb
							)
					(
					Select
							getdate(),
							@Cd_Usuario,
							@Tp_Oper,
							@Num_proc,
							@Cd_Tp_Tx,
							@DC,
							@Num_Lcto,
							Vlr_Ref_hea,
							Dt_Conv_hea,
							Cd_Tp_Par,
							Par_Moeda_hea,
							Vlr_Pgto_Rcto_hea,
							Dt_Pgto_Rcto_hea,
							Num_Rcb_hea
					from
							caixa_hou_exp_aer
					where 
							num_proc_hea = @Num_proc and cd_tp_tx = @cd_tp_tx and dc_hea = @DC and num_lcto = @Num_lcto
					)
			End
		if left(@Num_proc,2) = 'IA'
			Begin
				insert into
					Log_Caixa (
								Data_Cx,
								Cd_Usuario,
								Tp_Oper_Cx,
								Num_Proc_Cx,
								Cd_Tp_Tx,
								DC_Cx,
								Num_Lcto_Cx,
								Vlr_Ref,
								Dt_Conv,
								Cd_Tp_Par,
								Par_Moeda_Cx,
								Vlr_Pgto_Rcto,
								Dt_Pgto_Rcto_Cx,
								Num_Rcb
							)
					(
					Select
							getdate(),
							@Cd_Usuario,
							@Tp_Oper,
							@Num_proc,
							@Cd_Tp_Tx,
							@DC,
							@Num_Lcto,
							Vlr_Ref_hia,
							Dt_Conv_hia,
							Cd_Tp_Par,
							Par_Moeda_hia,
							Vlr_Pgto_Rcto_hia,
							Dt_Pgto_Rcto_hia,
							Num_Rcb_hia
					from
							caixa_hou_imp_aer
					where 
							num_proc_hia = @Num_proc and cd_tp_tx = @cd_tp_tx and dc_hia = @DC and num_lcto = @Num_lcto
					)
			End
		if left(@Num_proc,2) = 'EO'
			Begin
				insert into
					Log_Caixa (
								Data_Cx,
								Cd_Usuario,
								Tp_Oper_Cx,
								Num_Proc_Cx,
								Cd_Tp_Tx,
								DC_Cx,
								Num_Lcto_Cx,
								Vlr_Ref,
								Dt_Conv,
								Cd_Tp_Par,
								Par_Moeda_Cx,
								Vlr_Pgto_Rcto,
								Dt_Pgto_Rcto_Cx,
								Num_Rcb
							)
					(
					Select
							getdate(),
							@Cd_Usuario,
							@Tp_Oper,
							@Num_proc,
							@Cd_Tp_Tx,
							@DC,
							@Num_Lcto,
							Vlr_Ref_heo,
							Dt_Conv_heo,
							Cd_Tp_Par,
							Par_Moeda_heo,
							Vlr_Pgto_Rcto_heo,
							Dt_Pgto_Rcto_heo,
							Num_Rcb_heo
					from
							caixa_hou_exp_out
					where 
							num_proc_heo = @Num_proc and cd_tp_tx = @cd_tp_tx and dc_heo = @DC and num_lcto = @Num_lcto
					)
			End
		if left(@Num_proc,2) = 'IO'
			Begin
				insert into
					Log_Caixa (
								Data_Cx,
								Cd_Usuario,
								Tp_Oper_Cx,
								Num_Proc_Cx,
								Cd_Tp_Tx,
								DC_Cx,
								Num_Lcto_Cx,
								Vlr_Ref,
								Dt_Conv,
								Cd_Tp_Par,
								Par_Moeda_Cx,
								Vlr_Pgto_Rcto,
								Dt_Pgto_Rcto_Cx,
								Num_Rcb
							)
					(
					Select
							getdate(),
							@Cd_Usuario,
							@Tp_Oper,
							@Num_proc,
							@Cd_Tp_Tx,
							@DC,
							@Num_Lcto,
							Vlr_Ref_hio,
							Dt_Conv_hio,
							Cd_Tp_Par,
							Par_Moeda_hio,
							Vlr_Pgto_Rcto_hio,
							Dt_Pgto_Rcto_hio,
							Num_Rcb_hio
					from
							caixa_hou_imp_out
					where 
							num_proc_hio = @Num_proc and cd_tp_tx = @cd_tp_tx and dc_hio = @DC and num_lcto = @Num_lcto
					)
			End
	End
if len(@Num_proc) = 14
	Begin
		if left(@Num_proc,2) = 'EM'
			Begin
				insert into
					Log_Caixa (
								Data_Cx,
								Cd_Usuario,
								Tp_Oper_Cx,
								Num_Proc_Cx,
								Cd_Tp_Tx,
								DC_Cx,
								Num_Lcto_Cx,
								Vlr_Ref,
								Dt_Conv,
								Cd_Tp_Par,
								Par_Moeda_Cx,
								Vlr_Pgto_Rcto,
								Dt_Pgto_Rcto_Cx,
								Num_Rcb
							)
					(
					Select
							getdate(),
							@Cd_Usuario,
							@Tp_Oper,
							@Num_proc,
							@Cd_Tp_Tx,
							@DC,
							@Num_Lcto,
							Vlr_Ref_mem,
							Dt_Conv_mem,
							Cd_Tp_Par,
							Par_Moeda_mem,
							Vlr_Pgto_Rcto_mem,
							Dt_Pgto_Rcto_mem,
							Num_Rcb_mem
					from
							caixa_mas_exp_mar
					where 
							num_proc_mem = @Num_proc and cd_tp_tx = @cd_tp_tx and dc_mem = @DC and num_lcto = @Num_lcto
					)
			End
		if left(@Num_proc,2) = 'IM'
			Begin
				insert into
					Log_Caixa (
								Data_Cx,
								Cd_Usuario,
								Tp_Oper_Cx,
								Num_Proc_Cx,
								Cd_Tp_Tx,
								DC_Cx,
								Num_Lcto_Cx,
								Vlr_Ref,
								Dt_Conv,
								Cd_Tp_Par,
								Par_Moeda_Cx,
								Vlr_Pgto_Rcto,
								Dt_Pgto_Rcto_Cx,
								Num_Rcb
							)
					(
					Select
							getdate(),
							@Cd_Usuario,
							@Tp_Oper,
							@Num_proc,
							@Cd_Tp_Tx,
							@DC,
							@Num_Lcto,
							Vlr_Ref_mim,
							Dt_Conv_mim,
							Cd_Tp_Par,
							Par_Moeda_mim,
							Vlr_Pgto_Rcto_mim,
							Dt_Pgto_Rcto_mim,
							Num_Rcb_mim
					from
							caixa_mas_imp_mar
					where 
							num_proc_mim = @Num_proc and cd_tp_tx = @cd_tp_tx and dc_mim = @DC and num_lcto = @Num_lcto
					)
			End
		if left(@Num_proc,2) = 'EA'
			Begin
				insert into
					Log_Caixa (
								Data_Cx,
								Cd_Usuario,
								Tp_Oper_Cx,
								Num_Proc_Cx,
								Cd_Tp_Tx,
								DC_Cx,
								Num_Lcto_Cx,
								Vlr_Ref,
								Dt_Conv,
								Cd_Tp_Par,
								Par_Moeda_Cx,
								Vlr_Pgto_Rcto,
								Dt_Pgto_Rcto_Cx,
								Num_Rcb
							)
					(
					Select
							getdate(),
							@Cd_Usuario,
							@Tp_Oper,
							@Num_proc,
							@Cd_Tp_Tx,
							@DC,
							@Num_Lcto,
							Vlr_Ref_mea,
							Dt_Conv_mea,
							Cd_Tp_Par,
							Par_Moeda_mea,
							Vlr_Pgto_Rcto_mea,
							Dt_Pgto_Rcto_mea,
							Num_Rcb_mea
					from
							caixa_mas_exp_aer
					where 
							num_proc_mea = @Num_proc and cd_tp_tx = @cd_tp_tx and dc_mea = @DC and num_lcto = @Num_lcto
					)
			End
		if left(@Num_proc,2) = 'IA'
			Begin
				insert into
					Log_Caixa (
								Data_Cx,
								Cd_Usuario,
								Tp_Oper_Cx,
								Num_Proc_Cx,
								Cd_Tp_Tx,
								DC_Cx,
								Num_Lcto_Cx,
								Vlr_Ref,
								Dt_Conv,
								Cd_Tp_Par,
								Par_Moeda_Cx,
								Vlr_Pgto_Rcto,
								Dt_Pgto_Rcto_Cx,
								Num_Rcb
							)
					(
					Select
							getdate(),
							@Cd_Usuario,
							@Tp_Oper,
							@Num_proc,
							@Cd_Tp_Tx,
							@DC,
							@Num_Lcto,
							Vlr_Ref_mia,
							Dt_Conv_mia,
							Cd_Tp_Par,
							Par_Moeda_mia,
							Vlr_Pgto_Rcto_mia,
							Dt_Pgto_Rcto_mia,
							Num_Rcb_mia
					from
							caixa_mas_imp_aer
					where 
							num_proc_mia = @Num_proc and cd_tp_tx = @cd_tp_tx and dc_mia = @DC and num_lcto = @Num_lcto
					)
			End
	End

	if @@error <> 0
		Begin
			Rollback transaction
			return -1
		End

Commit Transaction

GO
