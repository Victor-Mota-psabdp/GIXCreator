SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_INT_Iata_HouseWaybill_IncludedCustomsNote_InsUpd]

	@ID_HouseWaybill			BigInt,
	@ID_IncludedCustomsNote		bigint,
	@Num_proc					varchar(16),
	@Type						varchar(200),
	@ContentCode				varchar(25),
	@Content					varchar(200),
	@SubjectCode				varchar(200),
	@CountryID					varchar(200)

AS
BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help Iata_HouseWaybill_IncludedCustomsNote
	BEGIN TRY
		Declare @ID_New as bigint;
			
		IF exists(select ID_HouseWaybill from ATL_INT.dbo.Iata_HouseWaybill_IncludedCustomsNote 
					where Num_proc = @Num_proc and SubjectCode =@SubjectCode)
			Begin
				Update
					ATL_INT.dbo.Iata_HouseWaybill_IncludedCustomsNote 
				Set
					--num_proc = @Num_proc,
					Type =@Type,
					ContentCode=@ContentCode,
					Content=@Content,			
					--SubjectCode=@SubjectCode,
					CountryID = @CountryID
				Where
					Num_proc = @Num_proc and SubjectCode =@SubjectCode				
			End
		Else
			BEGIN
				
				SET @ID_New=(SELECT ISNULL(MAX(ID_IncludedCustomsNote),0) FROM ATL_INT.dbo.Iata_HouseWaybill_IncludedCustomsNote where ID_HouseWaybill = @ID_HouseWaybill and Num_Proc = @Num_proc )+1
				
				Insert ATL_INT.dbo.Iata_HouseWaybill_IncludedCustomsNote
				(
					ID_HouseWaybill,ID_IncludedCustomsNote,Type,num_proc,
					ContentCode,Content,
                    SubjectCode,CountryID
				)
				Values
				(
					@ID_HouseWaybill,@ID_New,@Type,@Num_proc,
					@ContentCode,@Content,                    
                    @SubjectCode,@CountryID
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
