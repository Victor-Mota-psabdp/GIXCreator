SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spNotaFiscalBR_Selec_Upd]
	@Processo		varchar(16),
	@Taxa			varchar(50),
	@DC				char(1),
	@Num_nf			varchar(8),
	@Ref_Acesso_nf	char(1),
	@Vlr_Ptgo_Nf	float,	
	@Par_Nf			float
AS

		Declare @Cd_Tp_tx varchar(10)
		
		Set @Cd_Tp_Tx = (Select cd_tp_tx from tipo_taxa where nome_tp_tx = @Taxa)

Begin Transaction	
	If len(@Processo) = 16
		Begin
			If  left(@Processo,2) = 'BO'
				Begin
					update 
						Cta_Cte_HOU_BDP_OUT
					Set
						Num_NF_HBO = @Num_nf,
						Ref_Acesso_NF_HBO = @Ref_Acesso_nf,
						Vlr_Pgto_NF_HBO = @Vlr_Ptgo_Nf,
						Par_NF_HBO = @Par_Nf
					where
						Num_Proc_HBO = @Processo and Cd_Tp_Tx = @Cd_Tp_tx and DC_HBO = @DC 
				End
		
		
		
		
			If  left(@Processo,2) = 'EM'
				Begin
					update 
						cta_cte_hou_exp_mar
					Set
						Num_NF_Hem = @Num_nf,
						Ref_Acesso_nf_hem = @Ref_Acesso_nf,
						Vlr_Pgto_nf_hem = @Vlr_Ptgo_Nf,
						Par_nf_hem = @Par_Nf
					where
						Num_Proc_hem = @Processo and Cd_Tp_Tx = @Cd_Tp_tx and DC_HEM = @DC 
				End
 
			If  left(@Processo,2) = 'EA'
				Begin
					update 
						cta_cte_hou_exp_aer
					Set
						Num_NF_Hea = @Num_nf,
						Ref_Acesso_nf_hea = @Ref_Acesso_nf,
						Vlr_Pgto_nf_hea = @Vlr_Ptgo_Nf,
						Par_nf_hea = @Par_Nf
					where
						Num_Proc_hea = @Processo and Cd_Tp_Tx = @Cd_Tp_tx and DC_HEA = @DC 
				End

			If  left(@Processo,2) = 'EO'
				Begin
					update 
						cta_cte_hou_exp_out
					Set
						Num_NF_Heo = @Num_nf,
						Ref_Acesso_nf_heo = @Ref_Acesso_nf,
						Vlr_Pgto_nf_heo = @Vlr_Ptgo_Nf,
						Par_nf_heo = @Par_Nf
					where
						Num_Proc_heo = @Processo and Cd_Tp_Tx = @Cd_Tp_tx and DC_HEO = @DC 
				End

			If  left(@Processo,2) = 'IM'
				Begin
					update 
						cta_cte_hou_imp_mar
					Set
						Num_NF_Him = @Num_nf,
						Ref_Acesso_nf_him = @Ref_Acesso_nf,
						Vlr_Pgto_nf_him = @Vlr_Ptgo_Nf,
						Par_nf_him = @Par_Nf
					where
						Num_Proc_him = @Processo and Cd_Tp_Tx = @Cd_Tp_tx and DC_HIM = @DC 
				End

			If  left(@Processo,2) = 'IA'
				Begin
					update 
						cta_cte_hou_imp_aer
					Set
						Num_NF_Hia = @Num_nf,
						Ref_Acesso_nf_hia = @Ref_Acesso_nf,
						Vlr_Pgto_nf_hia = @Vlr_Ptgo_Nf,
						Par_nf_hia = @Par_Nf
					where
						Num_Proc_hia = @Processo and Cd_Tp_Tx = @Cd_Tp_tx and DC_HIA = @DC 
				End

			If  left(@Processo,2) = 'IO'
				Begin
					update 
						cta_cte_hou_imp_out
					Set
						Num_NF_Hio = @Num_nf,
						Ref_Acesso_nf_hio = @Ref_Acesso_nf,
						Vlr_Pgto_nf_hio = @Vlr_Ptgo_Nf,
						Par_nf_hio = @Par_Nf
					where
						Num_Proc_hio = @Processo and Cd_Tp_Tx = @Cd_Tp_tx and DC_HIO = @DC 
				End
			End

	If len(@Processo) = 14
		Begin
			If  left(@Processo,2) = 'EM'
				Begin
					update 
						cta_cte_mas_exp_mar
					Set
						Num_NF_mem = @Num_nf,
						Ref_Acesso_nf_mem = @Ref_Acesso_nf,
						Vlr_Pgto_nf_mem = @Vlr_Ptgo_Nf,
						Par_nf_mem = @Par_Nf
					where
						Num_Proc_mem = @Processo and Cd_Tp_Tx = @Cd_Tp_tx and DC_MEM = @DC 
				End
 
			If  left(@Processo,2) = 'EA'
				Begin
					update 
						cta_cte_mas_exp_aer
					Set
						Num_NF_mea = @Num_nf,
						Ref_Acesso_nf_mea = @Ref_Acesso_nf,
						Vlr_Pgto_nf_mea = @Vlr_Ptgo_Nf,
						Par_nf_mea = @Par_Nf
					where
						Num_Proc_mea = @Processo and Cd_Tp_Tx = @Cd_Tp_tx and DC_MEA = @DC 
				End


			If  left(@Processo,2) = 'IM'
				Begin
					update 
						cta_cte_mas_imp_mar
					Set
						Num_NF_mim = @Num_nf,
						Ref_Acesso_nf_mim = @Ref_Acesso_nf,
						Vlr_Pgto_nf_mim = @Vlr_Ptgo_Nf,
						Par_nf_mim = @Par_Nf
					where
						Num_Proc_mim = @Processo and Cd_Tp_Tx = @Cd_Tp_tx and DC_MIM = @DC 
				End

			If  left(@Processo,2) = 'IA'
				Begin
					update 
						cta_cte_mas_imp_aer
					Set
						Num_NF_Mia = @Num_nf,
						Ref_Acesso_nf_mia = @Ref_Acesso_nf,
						Vlr_Pgto_nf_mia = @Vlr_Ptgo_Nf,
						Par_nf_mia = @Par_Nf
					where
						Num_Proc_mia = @Processo and Cd_Tp_Tx = @Cd_Tp_tx and DC_MIA = @DC 
				End

			If  left(@Processo,2) = 'IM'
				Begin
					update 
						cta_cte_hou_imp_mar
					Set
						Num_NF_Him = @Num_nf,
						Ref_Acesso_nf_him = @Ref_Acesso_nf,
						Vlr_Pgto_nf_him = @Vlr_Ptgo_Nf,
						Par_nf_him = @Par_Nf
					where
						Num_Proc_him = @Processo and Cd_Tp_Tx = @Cd_Tp_tx and DC_HIM = @DC 
				End

			If  left(@Processo,2) = 'IA'
				Begin
					update 
						cta_cte_hou_imp_aer
					Set
						Num_NF_Hia = @Num_nf,
						Ref_Acesso_nf_hia = @Ref_Acesso_nf,
						Vlr_Pgto_nf_hia = @Vlr_Ptgo_Nf,
						Par_nf_hia = @Par_Nf
					where
						Num_Proc_hia = @Processo and Cd_Tp_Tx = @Cd_Tp_tx and DC_HIA = @DC 
				End
			End

IF @@Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END

Commit Transaction




GO
