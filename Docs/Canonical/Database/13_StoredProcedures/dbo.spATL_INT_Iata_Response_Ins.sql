SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_INT_Iata_Response_Ins]
(
	@ID				BigInt,
	@Num_Proc		varchar(16),
	@MessageHeaderDocument_ID	varchar(250),
	@MessageHeaderDocument_Name	varchar(250),
	@MessageHeaderDocument_TypeCode	varchar(250),
	@MessageHeaderDocument_IssueDateTime	varchar(250),
	@MessageHeaderDocument_PurposeCode	varchar(250),
	@MessageHeaderDocument_VersionID	varchar(250),
	@BusinessHeaderDocument_ID	varchar(250),
	@BusinessHeaderDocument_Name	varchar(250),
	@BusinessHeaderDocument_TypeCode	varchar(250),
	@BusinessHeaderDocument_IssueDateTime	varchar(250),
	@ID_Smart 	BigInt,
	@ID_GTNEXUS 	BigInt
)
AS
BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help Iata_Response
	BEGIN TRY
		Declare @ID_New as bigint;
		
		BEGIN			
			Insert ATL_INT.dbo.Iata_Response
			(
				Num_Proc,
				MessageHeaderDocument_ID,MessageHeaderDocument_Name,MessageHeaderDocument_TypeCode,MessageHeaderDocument_IssueDateTime,
				MessageHeaderDocument_PurposeCode,MessageHeaderDocument_VersionID,BusinessHeaderDocument_ID,BusinessHeaderDocument_Name,
				BusinessHeaderDocument_TypeCode,BusinessHeaderDocument_IssueDateTime,
				ID_Smart, ID_GTNEXUS 
			)
			Values
			(
				@Num_Proc,
				@MessageHeaderDocument_ID,@MessageHeaderDocument_Name,@MessageHeaderDocument_TypeCode,@MessageHeaderDocument_IssueDateTime,
				@MessageHeaderDocument_PurposeCode,@MessageHeaderDocument_VersionID,@BusinessHeaderDocument_ID,@BusinessHeaderDocument_Name,
				@BusinessHeaderDocument_TypeCode,@BusinessHeaderDocument_IssueDateTime,
				@ID_Smart, @ID_GTNEXUS 
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
