SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spEmix_Atualiza_JOB_UPD]

	@Num_Proc			VarChar(16),
	@Qtd_Tot_Vol		Float,
	@Peso_Bruto			Float,
	@Peso_Liquido		Float,
	@cd_tp_Moeda 		varchar(50),
	@Vlr_Invoice		float,
	@Moeda_INV			varchar(30)
 
 AS

Begin Transaction
	if LEFT(@Num_Proc,2) = 'EM'
		BEGIN
			UPDATE House_exp_Mar set Qtd_Tot_Vol_HEM = @Qtd_Tot_Vol,Peso_Bruto_HEM =@Peso_Bruto,Peso_Liquido_HEM = @Peso_Liquido,Cd_Tp_Moeda =@cd_tp_Moeda Where Num_Proc_Hem = @Num_Proc
			Update LLP_Exp_Mar set Vlr_Invoice = @Vlr_Invoice,Cd_Moeda_Invoice = @cd_tp_Moeda where Num_Proc_Lem = @Num_Proc
		END
	if LEFT(@Num_Proc,2) = 'EA'
		BEGIN
			UPDATE House_Exp_Aer set Qtd_Tot_Vol_HEA = @Qtd_Tot_Vol,Peso_Bruto_HEA =@Peso_Bruto,Peso_Real_HEA = @Peso_Liquido,Cd_Tp_Moeda =@cd_tp_Moeda Where Num_Proc_HEA = @Num_Proc
			Update LLP_Exp_Aer set Vlr_Invoice = @Vlr_Invoice,Cd_Moeda_Invoice = @cd_tp_Moeda where Num_Proc_Lea = @Num_Proc
		END
	if LEFT(@Num_Proc,2) = 'EO'
		BEGIN
			UPDATE House_Exp_Out set Qtd_Tot_Vol_HEO = @Qtd_Tot_Vol,Peso_Bruto_HEO =@Peso_Bruto,Peso_Real_HEO = @Peso_Liquido,Cd_Tp_Moeda =@cd_tp_Moeda Where Num_Proc_HEO = @Num_Proc
			Update LLP_Exp_Out set Vlr_Invoice = @Vlr_Invoice,Cd_Moeda_Invoice = @cd_tp_Moeda where Num_Proc_Leo = @Num_Proc
		END	
		
		
IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -1
			END

Commit Transaction 
GO
