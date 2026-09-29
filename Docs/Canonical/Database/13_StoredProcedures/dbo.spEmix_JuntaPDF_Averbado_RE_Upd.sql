SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spEmix_JuntaPDF_Averbado_RE_Upd]

	@num_proc varchar(16)
AS

Begin Transaction 
	
		update 
			Doc_Anexos_Emix
		set 
			dt_envio = GETDATE()
		Where
			num_proc = @num_proc		
	
		IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -1
			END

Commit Transaction 
GO
