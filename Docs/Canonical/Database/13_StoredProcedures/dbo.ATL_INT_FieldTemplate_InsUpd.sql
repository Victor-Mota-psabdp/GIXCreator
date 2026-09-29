SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[ATL_INT_FieldTemplate_InsUpd]
(
    @ID             bigint,
	@PK_Code        varchar(30),
	@Name           varchar(50),
    @TypeField      varchar(15),
	@Path           varchar(80),
	@CheckBox       bit
)
AS
BEGIN
	BEGIN TRY
		Declare @ID_New as bigint;
		BEGIN
		    SET @ID_New =(SELECT ISNULL(MAX(ID),0) FROM ATL_INT.DBO.LayoutField_Template where ID = @ID)
			IF @ID_New = 0
				BEGIN
				   Insert into ATL_INT.DBO.LayoutField_Template
				   (
						PK_Code, Name, TypeField, Path, CheckBox
				   )
				   Values
				   (
						@PK_Code, @Name, @TypeField, @Path, @CheckBox
				   )
					set @ID_New = @@IDENTITY
			   END
			ELSE
				BEGIN
				   Update ATL_INT.DBO.LayoutField_Template set
						PK_Code=@PK_Code, Name=@Name, TypeField=@TypeField, Path=@Path, CheckBox=@CheckBox
				   WHERE ID = @ID_NEW
			   END
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
