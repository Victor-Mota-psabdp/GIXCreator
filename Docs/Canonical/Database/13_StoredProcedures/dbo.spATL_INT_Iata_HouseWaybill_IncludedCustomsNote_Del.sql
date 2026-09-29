SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_INT_Iata_HouseWaybill_IncludedCustomsNote_Del]

	@ID_HouseWaybill			BigInt,
	@Num_proc					varchar(16),
	@Type						varchar(200)


AS
BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help Iata_HouseWaybill_IncludedCustomsNote
	BEGIN TRY
		Declare @ID_New as bigint;
			
		IF exists(select ID_HouseWaybill from ATL_INT.dbo.Iata_HouseWaybill_IncludedCustomsNote 
					where Num_proc = @Num_proc and Type =@Type)
			Begin
				Delete
					ATL_INT.dbo.Iata_HouseWaybill_IncludedCustomsNote 				
				Where
					Num_proc = @Num_proc and Type =@Type			
			End	

		Select @ID_HouseWaybill as Retorno;
		
		COMMIT TRAN
	END TRY

	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_MESSAGE() as Retorno;

	END CATCH	

END

GO
