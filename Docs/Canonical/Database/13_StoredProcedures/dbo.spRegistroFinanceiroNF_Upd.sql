SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spRegistroFinanceiroNF_Upd]
		@Num_Proc		Varchar(16),
		@Cd_Tp_Tx		Varchar(3),
		@DC				Char(1),		
		@Num_NF			Varchar(12)
		
AS

BEGIN TRANSACTION

	if exists(select * from vwcta_cte where num_proc_hia=@Num_Proc and cd_tp_Tx=@cd_tp_tx and dc_hia=@dc and num_nf_hia is not null)	
		BEGIN
			IF LEFT(@NUM_PROC,2)='IM' AND LEN(@NUM_PROC)=16
				BEGIN
					UPDATE
						cta_cte_hou_imp_mar
						set						
							Num_NF_HIM=Null						
					WHERE
							NUM_PROC_HIM=@NUM_PROC AND CD_TP_TX=@CD_tP_TX AND DC_HIM=@DC
							AND NUM_NF_HIM = @Num_NF
				END			

			IF LEFT(@NUM_PROC,2)='EM' AND LEN(@NUM_PROC)=16 							BEGIN
					UPDATE
						cta_cte_hou_EXP_MAR
							set
								Num_NF_HEM=Null
					WHERE
							NUM_PROC_HEM=@NUM_PROC AND CD_TP_TX=@CD_tP_TX AND DC_HEM=@DC
							AND NUM_NF_HEM = @Num_NF	
				END

			IF LEFT(@NUM_PROC,2)='IA' AND LEN(@NUM_PROC)=16					BEGIN
					UPDATE
						cta_cte_hou_imp_AER
							set									
								Num_NF_HIA=Null
						WHERE
							NUM_PROC_HIA=@NUM_PROC AND CD_TP_TX=@CD_tP_TX AND DC_HIA=@DC
							AND NUM_NF_HIA = @Num_NF	
				END

			IF LEFT(@NUM_PROC,2)='EA' AND LEN(@NUM_PROC)=16 					BEGIN
					UPDATE
						cta_cte_hou_EXP_AER
							set							
								Num_NF_HEA=Null							
						WHERE
								NUM_PROC_HEA=@NUM_PROC AND CD_TP_TX=@CD_tP_TX AND DC_HEA=@DC
								AND NUM_NF_Hea = @Num_NF
				END

			IF LEFT(@NUM_PROC,2)='IO' AND LEN(@NUM_PROC)=16 					BEGIN
					UPDATE
						cta_cte_hou_imp_OUT
							set							
								Num_NF_HIO=Null	
						WHERE
								NUM_PROC_HIO=@NUM_PROC AND CD_TP_TX=@CD_tP_TX AND DC_HIO=@DC
								AND NUM_NF_HIO = @Num_NF
				END
	
			IF LEFT(@NUM_PROC,2)='EO' AND LEN(@NUM_PROC)=16					BEGIN
					UPDATE
						cta_cte_hou_EXP_OUT
							set							
								Num_NF_HEO=Null
						WHERE
								NUM_PROC_HEO=@NUM_PROC AND CD_TP_TX=@CD_tP_TX AND DC_HEO=@DC
								AND NUM_NF_HEO = @Num_NF
				END
				
			IF LEFT(@NUM_PROC,2)='BO' AND LEN(@NUM_PROC)=16					BEGIN
					UPDATE
						Cta_Cte_HOU_BDP_OUT
							set							
								Num_NF_HBO=Null
						WHERE
								NUM_PROC_HBO=@NUM_PROC AND CD_TP_TX=@CD_tP_TX AND DC_HBO=@DC
								AND NUM_NF_HBO = @Num_NF
				END

	-----------------------------------------------------------------------------------------------
			IF LEFT(@NUM_PROC,2)='IM' AND LEN(@NUM_PROC)=14		
				BEGIN
					UPDATE
						cta_cte_mas_imp_mar
						set							
							Num_NF_MIM=Null	
					WHERE
							NUM_PROC_MIM=@NUM_PROC AND CD_TP_TX=@CD_tP_TX AND DC_MIM=@DC
							AND NUM_NF_MIM = @Num_NF	
				END
		
			IF LEFT(@NUM_PROC,2)='EM' AND LEN(@NUM_PROC)=14		
				BEGIN
					UPDATE
						cta_cte_mas_EXP_mar
						set							
							Num_NF_MEM=Null	
					WHERE
							NUM_PROC_MEM=@NUM_PROC AND CD_TP_TX=@CD_tP_TX AND DC_MEM=@DC
							AND NUM_NF_MEM = @Num_NF
				END
		
			IF LEFT(@NUM_PROC,2)='IA' AND LEN(@NUM_PROC)=14		
					BEGIN
						UPDATE
							cta_cte_mas_Imp_Aer
							set							
								Num_NF_MIA=Null	
						WHERE
								NUM_PROC_MIA=@NUM_PROC AND CD_TP_TX=@CD_tP_TX AND DC_MIA=@DC
								AND NUM_NF_MIA = @Num_NF	
				END		

			IF LEFT(@NUM_PROC,2)='EA' AND LEN(@NUM_PROC)=14		
					BEGIN
						UPDATE
							cta_cte_mas_EXP_AER
							set						
								Num_NF_MEA=Null	
								
						WHERE
								NUM_PROC_MEA=@NUM_PROC AND CD_TP_TX=@CD_tP_TX AND DC_MEA=@DC
								AND NUM_NF_MEA = @Num_NF
					END
		END

if @@error <> 0
	BEGIN
		ROLLBACK TRANSACTION		
	END

COMMIT TRANSACTION
		








GO
