SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[spATL_LogPibernat_SelUpd] -- '%JOB%'
	@Status varchar(50)
as
	Begin Transaction
		select Arquivo, DataIns [Data do Envio], Status from log_pibernat With(nolock)
		where status like @Status and DataEnvPibernat is null 

		update log_pibernat set DataEnvPibernat = Getdate()
		where status like @Status and DataEnvPibernat is null 
	IF @@ERROR <> 0
		BEGIN
			RETURN -1
		END
COMMIT TRANSACTION

GO
