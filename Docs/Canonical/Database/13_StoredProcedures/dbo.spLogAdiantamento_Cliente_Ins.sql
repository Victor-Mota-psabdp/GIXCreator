SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE	Procedure [dbo].[spLogAdiantamento_Cliente_Ins]--'admin','D','IMSUN201201001BR',14027,'07086'	
	@Cd_Usuario		varchar	(6),
	@Tp_Oper_ADD	char	(1),
	@JOB			varchar	(16),
	@ID				int,
	@POC			varchar(5)
	

AS

BEGIN TRANSACTION

	Insert into Log_Adiantamento_Cliente
		(
		Data_add,
		cd_usuario,
		tp_oper_add,
		ID,
		Job,
		POC
		)
	Values
		(
		getDate(),
		@Cd_Usuario,
		@Tp_Oper_ADD,		
		@ID,
		@JOB,
		@POC	
		)
	IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END

COMMIT TRANSACTION
GO
