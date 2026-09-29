SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_INT_Iata_HouseManifest_Party_InsUpd]

	@ID_HouseManifest		BigInt,
	@ID_Party			bigint,
	@Type				varchar(25),
	@schemeID			varchar(200),
	@Value				varchar(200)

AS
BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help Iata_HouseManifest_Party
	BEGIN TRY
		Declare @ID_New as bigint;
			
		IF exists(select ID_HouseManifest from ATL_INT.dbo.Iata_HouseManifest_Party where ID_HouseManifest = @ID_HouseManifest and ID_Party = @ID_Party)
			Begin
				Update
					Iata_HouseManifest_Party
				Set
					Type=@Type,
					schemeID=@schemeID,			
					Value=@Value					

				Where
					ID_HouseManifest = @ID_HouseManifest 
					and ID_Party = @ID_Party				
			End
		Else
			BEGIN
				
				SET @ID_New=(SELECT ISNULL(MAX(ID_Party),0) FROM ATL_INT.dbo.Iata_HouseManifest_Party where ID_HouseManifest = @ID_HouseManifest )+1
				
				Insert ATL_INT.dbo.Iata_HouseManifest_Party
				(
					ID_HouseManifest,ID_Party,
					Type,schemeID,
                    Value
				)
				Values
				(
					@ID_HouseManifest,@ID_New,
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
