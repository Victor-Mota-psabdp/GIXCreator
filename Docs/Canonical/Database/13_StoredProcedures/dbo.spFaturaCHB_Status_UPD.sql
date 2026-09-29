SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spFaturaCHB_Status_UPD]-- null,'IMVPF20100300101','01-20-2010','VILA PORTO'
		@FatCod 	VarChar(17)
AS

BEGIN TRANSACTION

	if @FatCod is not null
		update Fatura_CHB
			set Status_PC='C' 
			where fatura_pc=@FatCod
		

	IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION 
			RETURN -2
		END

COMMIT TRANSACTION













GO
