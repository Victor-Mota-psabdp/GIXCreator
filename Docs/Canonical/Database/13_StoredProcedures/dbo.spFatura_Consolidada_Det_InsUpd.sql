SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from Fatura_Consolidada
--select * from Fatura_Consolidada_Det
CREATE Procedure [dbo].[spFatura_Consolidada_Det_InsUpd]

		@ID	 			Int,
		@FatCod			VarChar(17),
		@vlr_Org		float		

as


BEGIN TRANSACTION
		INSERT INTO
			Fatura_Consolidada_Det
				(
				ID,
				FatCod,
				Vlr_Org
				)			
			VALUES
				(
				@ID,
				@FatCod,
				@Vlr_Org
				)			
			
	IF @@ERROR <> 0 
		BEGIN 
			ROLLBACK TRANSACTION
			RETURN -1
		END
COMMIT TRANSACTION














GO
