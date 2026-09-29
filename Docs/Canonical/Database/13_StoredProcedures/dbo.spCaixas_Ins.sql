SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE	PROCEDURE [dbo].[spCaixas_Ins]
(
@Num_Proc			varchar	(16),
@Cd_Tp_Tx			varchar	(3),
@DC					char	(1),
@Num_Lcto			varchar	(12),
@Vlr_Ref			float	,
@Dt_Conv			varchar	(10),
@Cd_Tp_Par			varchar	(3),
@Par_Moeda			float	(9),
@Vlr_Pgto_Rcto		float (9),
@Dt_Pgto_Rcto		varchar	(10),
@Num_ND				varchar	(12),
@Num_Bx				varchar	(12),
@Num_NF				varchar	(12),
@Num_Rcb			varchar	(12),
@Dt_Ctb_Cx			varchar	(10)
)

AS

BEGIN TRANSACTION
--Adicionado o return 0 pra nao inserir pgto novos - 07/02/14 - Cadu
		return 0

	if not exists(select * from vwcxas where cd_tp_Tx=@cd_Tp_Tx and num_proc_hia=@num_proc and dc_hia=@DC)
		Begin

			if Left(@Num_Proc,2) = 'EA'
			Begin
				Insert Into caixa_hou_exp_aer
						(
							Num_Proc_HEA,
							Cd_Tp_Tx,
							DC_HEA,
							Num_Lcto,
							Vlr_Ref_HEA,
							Dt_Conv_HEA,
							Cd_Tp_Par,
							Par_Moeda_HEA,
							Vlr_Pgto_Rcto_HEA,
							Dt_Pgto_Rcto_HEA,
							Num_ND_HEA,
							Num_Bx_HEA,
							Num_NF_HEA,
							Num_Rcb_HEA,
							Dt_Ctb_Cx_HEA
						)
					Values
						(
							@Num_Proc,
							@Cd_Tp_Tx,
							@DC,
							@Num_Lcto,
							@Vlr_Ref,
							@Dt_Conv,
							@Cd_Tp_Par,
							@Par_Moeda,
							@Vlr_Pgto_Rcto,
							@Dt_Pgto_Rcto,
							@Num_ND,
							@Num_Bx,
							@Num_NF,
							@Num_Rcb,
							@Dt_Ctb_Cx
						)
			End

			Else if Left(@Num_Proc,2) = 'EM'
			Begin
				Insert Into caixa_hou_exp_mar
						(
							Num_Proc_HEM,
							Cd_Tp_Tx,
							DC_HEM,
							Num_Lcto,
							Vlr_Ref_HEM,
							Dt_Conv_HEM,
							Cd_Tp_Par,
							Par_Moeda_HEM,
							Vlr_Pgto_Rcto_HEM,
							Dt_Pgto_Rcto_HEM,
							Num_ND_HEM,
							Num_Bx_HEM,
							Num_NF_HEM,
							Num_Rcb_HEM,
							Dt_Ctb_Cx_HEM
						)
					Values
						(
							@Num_Proc,
							@Cd_Tp_Tx,
							@DC,
							@Num_Lcto,
							@Vlr_Ref,
							@Dt_Conv,
							@Cd_Tp_Par,
							@Par_Moeda,
							@Vlr_Pgto_Rcto,
							@Dt_Pgto_Rcto,
							@Num_ND,
							@Num_Bx,
							@Num_NF,
							@Num_Rcb,
							@Dt_Ctb_Cx
						)
			End

			Else if Left(@Num_Proc,2) = 'EO'
			Begin
				Insert Into caixa_hou_exp_out
						(
							Num_Proc_HEO,
							Cd_Tp_Tx,
							DC_HEO,
							Num_Lcto,
							Vlr_Ref_HEO,
							Dt_Conv_HEO,
							Cd_Tp_Par,
							Par_Moeda_HEO,
							Vlr_Pgto_Rcto_HEO,
							Dt_Pgto_Rcto_HEO,
							Num_ND_HEO,
							Num_Bx_HEO,
							Num_NF_HEO,
							Num_Rcb_HEO,
							Dt_Ctb_Cx_HEO
						)
					Values
						(
							@Num_Proc,
							@Cd_Tp_Tx,
							@DC,
							@Num_Lcto,
							@Vlr_Ref,
							@Dt_Conv,
							@Cd_Tp_Par,
							@Par_Moeda,
							@Vlr_Pgto_Rcto,
							@Dt_Pgto_Rcto,
							@Num_ND,
							@Num_Bx,
							@Num_NF,
							@Num_Rcb,
							@Dt_Ctb_Cx
						)
			End

			Else if Left(@Num_Proc,2) = 'IA'
			Begin
				Insert Into caixa_hou_imp_aer
						(
							Num_Proc_HIA,
							Cd_Tp_Tx,
							DC_HIA,
							Num_Lcto,
							Vlr_Ref_HIA,
							Dt_Conv_HIA,
							Cd_Tp_Par,
							Par_Moeda_HIA,
							Vlr_Pgto_Rcto_HIA,
							Dt_Pgto_Rcto_HIA,
							Num_ND_HIA,
							Num_Bx_HIA,
							Num_NF_HIA,
							Num_Rcb_HIA,
							Dt_Ctb_Cx_HIA
						)
					Values
						(
							@Num_Proc,
							@Cd_Tp_Tx,
							@DC,
							@Num_Lcto,
							@Vlr_Ref,
							@Dt_Conv,
							@Cd_Tp_Par,
							@Par_Moeda,
							@Vlr_Pgto_Rcto,
							@Dt_Pgto_Rcto,
							@Num_ND,
							@Num_Bx,
							@Num_NF,
							@Num_Rcb,
							@Dt_Ctb_Cx
						)
			End

			Else if Left(@Num_Proc,2) = 'IM'
			Begin
				Insert Into caixa_hou_imp_mar
						(
							Num_Proc_HIM,
							Cd_Tp_Tx,
							DC_HIM,
							Num_Lcto,
							Vlr_Ref_HIM,
							Dt_Conv_HIM,
							Cd_Tp_Par,
							Par_Moeda_HIM,
							Vlr_Pgto_Rcto_HIM,
							Dt_Pgto_Rcto_HIM,
							Num_ND_HIM,
							Num_Bx_HIM,
							Num_NF_HIM,
							Num_Rcb_HIM,
							Dt_Ctb_Cx_HIM
						)
					Values
						(
							@Num_Proc,
							@Cd_Tp_Tx,
							@DC,
							@Num_Lcto,
							@Vlr_Ref,
							@Dt_Conv,
							@Cd_Tp_Par,
							@Par_Moeda,
							@Vlr_Pgto_Rcto,
							@Dt_Pgto_Rcto,
							@Num_ND,
							@Num_Bx,
							@Num_NF,
							@Num_Rcb,
							@Dt_Ctb_Cx
						)
			End

			Else if Left(@Num_Proc,2) = 'IO'
			Begin
				Insert Into caixa_hou_imp_out
						(
							Num_Proc_HIO,
							Cd_Tp_Tx,
							DC_HIO,
							Num_Lcto,
							Vlr_Ref_HIO,
							Dt_Conv_HIO,
							Cd_Tp_Par,
							Par_Moeda_HIO,
							Vlr_Pgto_Rcto_HIO,
							Dt_Pgto_Rcto_HIO,
							Num_ND_HIO,
							Num_Bx_HIO,
							Num_NF_HIO,
							Num_Rcb_HIO,
							Dt_Ctb_Cx_HIO
						)
					Values
						(
							@Num_Proc,
							@Cd_Tp_Tx,
							@DC,
							@Num_Lcto,
							@Vlr_Ref,
							@Dt_Conv,
							@Cd_Tp_Par,
							@Par_Moeda,
							@Vlr_Pgto_Rcto,
							@Dt_Pgto_Rcto,
							@Num_ND,
							@Num_Bx,
							@Num_NF,
							@Num_Rcb,
							@Dt_Ctb_Cx
						)
			End
	end
	IF @@Error <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END

Commit Transaction 



GO
