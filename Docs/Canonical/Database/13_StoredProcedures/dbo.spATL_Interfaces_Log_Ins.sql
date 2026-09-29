SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_Interfaces_Log_Ins]

	@ID_Interface		int,
	@Descr_Interface 	Varchar(50),
	@Fluxo				Varchar(5),
	@Integrado			bit,
	@Arquivo			Varchar(100),	
	@Mensagem			Varchar(500)
	

AS

BEGIN TRANSACTION

	BEGIN
		INSERT INTO	ATL_Interfaces_Log
			(ID_Interface,Descr_Interface,Fluxo,Integrado,Arquivo,Mensagem,data)					
		VALUES
			(@ID_Interface,@Descr_Interface,@Fluxo,@Integrado,@Arquivo,@Mensagem,getdate())	
	END

IF @@Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END


COMMIT TRANSACTION







GO
