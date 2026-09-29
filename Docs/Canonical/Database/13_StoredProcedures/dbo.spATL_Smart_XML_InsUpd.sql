SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Smart_XML
--select * from Smart_XML where dt_ins> getdate() -1
CREATE Procedure [dbo].[spATL_Smart_XML_InsUpd]
(
	@ID_Smart			bigint,	
	@Num_Proc			varchar(16),
	@XML_DOC			nvarchar(MAX),
	@Nome_Arquivo		Varchar(100),
	@Dt_Ins				Datetime,
	@Dt_Envio			Datetime
)

AS
BEGIN
	BEGIN TRY	
		if exists(select ID_Smart from ATL_INT.dbo.Smart_XML where ID_Smart = @ID_Smart and Num_Proc = @Num_Proc)
			BEGIN
				Update
					ATL_INT.dbo.Smart_XML
				set					
					Dt_Envio = @Dt_Envio
				where 
					ID_Smart = @ID_Smart and 
					Num_Proc = @Num_Proc
			End
		Else	
			BEGIN
				Insert ATL_INT.dbo.Smart_XML 
				(
					Num_Proc,XML_DOC,Nome_Arquivo,Dt_Ins,Dt_Envio
				)
				Values
				(
					@Num_Proc,@XML_DOC,@Nome_Arquivo,getdate(),NULL
				)	

				set @ID_Smart = @@IDENTITY;				
			END	
	
		
		Select @ID_Smart as Retorno;		
		
		COMMIT TRAN
	END TRY

	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_MESSAGE() as Retorno;

	END CATCH	

END

GO
