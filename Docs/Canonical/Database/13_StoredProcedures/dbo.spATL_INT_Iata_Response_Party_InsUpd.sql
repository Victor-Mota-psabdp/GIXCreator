SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_INT_Iata_Response_Party_InsUpd]

	@ID_Response		BigInt,
	@ID_Party			bigint,
	@Type				varchar(25),
	@schemeID			varchar(200),
	@Value				varchar(200)

AS
BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help Iata_Response_Party
	BEGIN TRY
		Declare @ID_New as bigint;
			
		IF exists(select ID_Response from ATL_INT.dbo.Iata_Response_Party where ID_Response = @ID_Response and ID_Party = @ID_Party)
			Begin
				Update
					Iata_Response_Party
				Set
					Type=@Type,
					schemeID=@schemeID,			
					Value=@Value					

				Where
					ID_Response = @ID_Response 
					and ID_Party = @ID_Party				
			End
		Else
			BEGIN
				
				SET @ID_New=(SELECT ISNULL(MAX(ID_Party),0) FROM ATL_INT.dbo.Iata_Response_Party where ID_Response = @ID_Response )+1
				
				Insert ATL_INT.dbo.Iata_Response_Party
				(
					ID_Response,ID_Party,
					Type,schemeID,
                    Value
				)
				Values
				(
					@ID_Response,@ID_New,
					@Type,@schemeID,                    
                    @Value
				)
			END	

		Select @ID_New as Retorno;
		
		COMMIT TRAN
	END TRY

	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_MESSAGE() as Retorno;

	END CATCH	

END

GO
