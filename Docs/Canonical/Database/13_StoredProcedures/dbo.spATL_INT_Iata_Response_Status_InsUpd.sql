SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_INT_Iata_Response_Status_InsUpd]

	@ID_Response		BigInt,
	@ID_Status			bigint,
	@ConditionCode		varchar(200),
	@Reason				varchar(MAX)

AS
BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help Iata_Response_Status
	BEGIN TRY
		Declare @ID_New as bigint;
			
		IF exists(select ID_Response from ATL_INT.dbo.Iata_Response_Status where ID_Response = @ID_Response and ID_Status = @ID_Status)
			Begin
				Update
					Iata_Response_Status
				Set					
					ConditionCode=@ConditionCode,			
					Reason=@Reason					

				Where
					ID_Response = @ID_Response 
					and ID_Status = @ID_Status				
			End
		Else
			BEGIN
				
				SET @ID_New=(SELECT ISNULL(MAX(ID_Status),0) FROM ATL_INT.dbo.Iata_Response_Status where ID_Response = @ID_Response )+1
				
				Insert ATL_INT.dbo.Iata_Response_Status
				(
					ID_Response,ID_Status,
					ConditionCode,
                    Reason
				)
				Values
				(
					@ID_Response,@ID_New,
					@ConditionCode,                    
                    @Reason
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
