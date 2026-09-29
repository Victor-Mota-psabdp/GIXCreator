SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[spATL_INT_Iata_Received_List_Errorlist_InsUpd]

	@ID_Received		BigInt,
	@ID_ErrorList			bigint,
	@code				varchar(25),
	@description			varchar(200),
	@detail				varchar(200)

AS
BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help Iata_Received_List_Errorlist
	BEGIN TRY
		Declare @ID_New as bigint;
			
		IF exists(select ID_Received from ATL_INT.dbo.Iata_Received_List_Errorlist where ID_Received = @ID_Received and ID_ErrorList = @ID_ErrorList)
			Begin
				Update
					Iata_Received_List_Errorlist
				Set
					code=@code,
					description=@description,			
					detail=@detail	
				Where
					ID_Received = @ID_Received 
					and ID_ErrorList = @ID_ErrorList				
			End
		Else
			BEGIN
				
				SET @ID_New=(SELECT ISNULL(MAX(ID_ErrorList),0) FROM ATL_INT.dbo.Iata_Received_List_Errorlist where ID_Received = @ID_Received )+1
				
				Insert ATL_INT.dbo.Iata_Received_List_Errorlist
				(
					ID_Received,ID_ErrorList,
					code,description,
                    detail
				)
				vALUES
				(
					@ID_Received,@ID_New,
					@code,@description,                    
                    @detail
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
