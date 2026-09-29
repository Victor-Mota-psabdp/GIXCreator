SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spCtaCte_Del]
			@Num_Proc		Varchar(16),
			@Nome_Tp_tx		Varchar(50),
			@DC				Char(1)

AS

Declare @cd_tp_tx varchar(3)
/*
Utilizada para exclusão de conta-corrente
*/

Set @cd_tp_tx=(select top 1 cd_tp_tx from tipo_taxa where nome_tp_tx=@nome_tp_tx)

		--Erbson 08-01-2014: Não GRAVA CASO JÁ TENHA AX_DOC	
		if len(@Num_Proc) = 16
			Begin
				IF EXISTS(select id_AX from vwAXDocs where num_proc = @Num_Proc and cd_tp_tx_atl = @Cd_Tp_Tx and DC = @DC)
					BEGIN
						RETURN -2
					END
			End
		else
		Begin
				IF EXISTS(select id_AX from vwAXDocs where NumeroInternoAX = @Num_Proc and cd_tp_tx_atl = @Cd_Tp_Tx and DC = @DC)
					BEGIN
						RETURN -2
					END
		End
		
Declare @UltimaFatura varchar(50)
Set @UltimaFatura =(select dbo.[FBusca_UltimaFatura](@Num_Proc,@DC,@Cd_Tp_Tx))
			IF @UltimaFatura is not null and @UltimaFatura <> ''
			BEGIN
				RETURN -2
			END
Begin Transaction

	if left(@num_proc,2)='EA' and len(@num_proc)=16
		Begin
			Delete
				Cta_Cte_hou_exp_Aer
			Where
				num_proc_hea=@num_proc and cd_tp_Tx=@cd_tp_tx and dc_hea=@dc 
				and (num_nf_hea is null or num_nf_hea='')
		End
	
	if left(@num_proc,2)='EA' and len(@num_proc)=14
		Begin
			Delete
				Cta_Cte_mas_exp_Aer
			Where
				num_proc_mea=@num_proc and cd_tp_Tx=@cd_tp_tx and dc_mea=@dc
				and (num_nf_mea is null or num_nf_mea='')
		End

	if left(@num_proc,2)='IA' and len(@num_proc)=16
		Begin
			Delete
				Cta_Cte_hou_IMP_Aer
			Where
				num_proc_hia=@num_proc and cd_tp_Tx=@cd_tp_tx and dc_hia=@dc 
				and (num_nf_hia is null or num_nf_hia='')
		End
	
	if left(@num_proc,2)='IA' and len(@num_proc)=14
		Begin
			Delete
				Cta_Cte_mas_imp_Aer
			Where
				num_proc_mia=@num_proc and cd_tp_Tx=@cd_tp_tx and dc_mia=@dc 
				and (num_nf_mia is null or num_nf_mia='')
		End


	if left(@num_proc,2)='IM' and len(@num_proc)=16
		Begin
			Delete
				Cta_Cte_hou_IMP_MAR
			Where
				num_proc_hiM=@num_proc and cd_tp_Tx=@cd_tp_tx and dc_hiM=@dc 
				and (num_nf_hiM is null or num_nf_hiM='')
		End
	
	if left(@num_proc,2)='IM' and len(@num_proc)=14
		Begin
			Delete
				Cta_Cte_mas_imp_MAR
			Where
				num_proc_miM=@num_proc and cd_tp_Tx=@cd_tp_tx and dc_miM=@dc 
				and (num_nf_miM is null or num_nf_miM='')
		End

	if left(@num_proc,2)='IO' and len(@num_proc)=16
		Begin
			Delete
				Cta_Cte_hou_IMP_OUT
			Where
				num_proc_hiO=@num_proc and cd_tp_Tx=@cd_tp_tx and dc_hiO=@dc 
				and (num_nf_hiO is null or num_nf_hiO='')
		End
	
	if left(@num_proc,2)='EO' 
		Begin
			Delete
				Cta_Cte_hou_EXP_OUT
			Where
				num_proc_HEO=@num_proc and cd_tp_Tx=@cd_tp_tx and dc_HEO=@dc 
				and (num_nf_HEO is null or num_nf_HEO='')
		End

	if left(@num_proc,2)='EM' and len(@num_proc)=16
		Begin
			Delete
				Cta_Cte_hou_exP_MAR
			Where
				num_proc_heM=@num_proc and cd_tp_Tx=@cd_tp_tx and dc_heM=@dc 
				and (num_nf_heM is null or num_nf_heM='')
		End
	
	if left(@num_proc,2)='EM' and len(@num_proc)=14
		Begin
			Delete
				Cta_Cte_mas_exp_MAR
			Where
				num_proc_meM=@num_proc and cd_tp_Tx=@cd_tp_tx and dc_meM=@dc 
				and (num_nf_meM is null or num_nf_meM='')
		End

	if left(@num_proc,2)='BO' and len(@num_proc)=16
		Begin
			Delete
				Cta_Cte_HOU_BDP_OUT
			Where
				num_proc_hbo=@num_proc and cd_tp_Tx=@cd_tp_tx and dc_hbo=@dc 
				and (num_nf_hbo is null or num_nf_hbo='')
		End

IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END
	
Commit transaction



GO
