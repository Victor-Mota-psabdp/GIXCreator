SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_INT_Iata_Received_List_Ins]

	@ID				BigInt,
	@protocolNumber	varchar(250),
	@dateTime	datetime,
	@fileType	varchar(250),
	@status	varchar(250),
	@cpf	varchar(250),
	@cnpj	varchar(250)


AS
BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help Iata_Received_List
	BEGIN TRY
		Declare @ID_New as bigint;
		
		BEGIN			
			Insert ATL_INT.dbo.Iata_Received_List
			(				
				protocolNumber,dateTime,fileType,status,cpf,cnpj
			)
			Values
			(				
				@protocolNumber,@dateTime,@fileType,@status,@cpf,@cnpj
			)
		END	
		
		set @ID_New = @@IDENTITY;
		Select @ID_New as Retorno;				
		

		COMMIT TRAN
	END TRY

	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_MESSAGE() as Retorno;

	END CATCH	

END

GO
