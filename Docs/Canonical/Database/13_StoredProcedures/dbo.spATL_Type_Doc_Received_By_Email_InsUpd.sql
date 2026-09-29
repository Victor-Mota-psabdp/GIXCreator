SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[spATL_Type_Doc_Received_By_Email_InsUpd]
( 
	@ID					bigint,
	@From				varchar(200),
	@Subject			varchar(200),
	@Doc_Extension		varchar(20),
	@Destination_Folder varchar(MAX),
	@Emails				varchar(2500),
	@Cd_Tipo			varchar(1),
    @Cd_Usuario			varchar(6),
    @Ativo				bit,
    @Dt_Ins				datetime,
	@Doc_Full_Name		bit	
 )
  
AS
BEGIN

	BEGIN TRY

		BEGIN TRANSACTION;
		
		Declare @ID_New as bigint;


	If  exists (select ID from ATL_INT.[dbo].Type_Doc_Received_By_Email where ID = @ID)
		Begin
			Update
				ATL_INT.[dbo].Type_Doc_Received_By_Email
			Set					
				[From] = @From,
				Subject = @Subject,
				Doc_Extension = @Doc_Extension,
				Destination_Folder = @Destination_Folder,
				Emails = @Emails,
				Cd_Tipo = @Cd_Tipo,
				Ativo =@Ativo,
				Cd_Usuario = @Cd_Usuario,
				Dt_Ins = GETDATE(),
				Doc_Full_Name=@Doc_Full_Name				
			Where
				ID = @ID

				set @ID_New = @ID

		End
	Else
		Begin
			Insert into
				ATL_INT.[dbo].Type_Doc_Received_By_Email
				([From], Subject, Doc_Extension, Destination_Folder, Emails, Cd_Tipo, Ativo, Cd_Usuario, Dt_ins,Doc_Full_Name)
			values
				(@FROM, @SUBJECT, @DOC_EXTENSION, @DESTINATION_FOLDER, @Emails, @Cd_Tipo,@Ativo,@Cd_Usuario,GETDATE(),@Doc_Full_Name	)

				set @ID_New = @@IDENTITY;

		End

		Select @ID_New as Retorno;	

Commit Transaction

END TRY

	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_MESSAGE() as Retorno;

	END CATCH	

END

GO
