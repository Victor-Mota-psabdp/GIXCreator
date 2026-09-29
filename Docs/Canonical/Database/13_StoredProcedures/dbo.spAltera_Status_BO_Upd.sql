SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spAltera_Status_BO_Upd]	
	@Num_Proc	varchar(16),	
	@Status		int
	
AS

Begin Transaction

		IF exists(select Num_Proc from vwCliente_Alerta where Num_Proc = @Num_Proc)
			BEGIN
				if LEFT(@Num_Proc,2) = 'BO'
					BEGIN
						update LLP_BDP_OUT 
							SET id_Status=@Status 
						where 
							Num_Proc_LBO=@Num_Proc
					END
			END
	IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -1
			END
Commit Transaction
GO
