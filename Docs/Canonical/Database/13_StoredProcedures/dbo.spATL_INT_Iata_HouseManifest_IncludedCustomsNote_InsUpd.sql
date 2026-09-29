SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_INT_Iata_HouseManifest_IncludedCustomsNote_InsUpd]

	@ID_HouseManifest			BigInt,
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
--sp_help Iata_HouseManifest_IncludedCustomsNote
	BEGIN TRY
		Declare @ID_New as bigint;
		Declare @OrderBy as int;
		if	@ContentCode = 'DI' 	
			set @OrderBy = 1
		else
			set @OrderBy = 2
			
		IF exists(select ID_HouseManifest from ATL_INT.dbo.Iata_HouseManifest_IncludedCustomsNote 
					where Num_proc = @Num_proc and ContentCode = @ContentCode and Type = @Type)
			Begin
				Update
					ATL_INT.dbo.Iata_HouseManifest_IncludedCustomsNote 
				Set
					num_proc = @Num_proc,
					Type =@Type,
					ContentCode=@ContentCode,
					Content=@Content,			
					SubjectCode=@SubjectCode,
					CountryID = @CountryID	
				Where
					 Num_proc = @Num_proc 
					 and ContentCode = @ContentCode		
					 and Type = @Type
			End
		Else
			BEGIN
				
				SET @ID_New=(SELECT ISNULL(MAX(ID_IncludedCustomsNote),0) FROM ATL_INT.dbo.Iata_HouseManifest_IncludedCustomsNote 
					where ID_HouseManifest = @ID_HouseManifest and Num_Proc = @Num_proc )+1
				
				Insert ATL_INT.dbo.Iata_HouseManifest_IncludedCustomsNote
				(
					ID_HouseManifest,ID_IncludedCustomsNote,Type,num_proc,
					ContentCode,Content,
                    SubjectCode,CountryID,
					OrderBy
				)
				Values
				(
					@ID_HouseManifest,@ID_New,@Type,@Num_proc,
					@ContentCode,@Content,                    
                    @SubjectCode,@CountryID,
					@OrderBy
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
