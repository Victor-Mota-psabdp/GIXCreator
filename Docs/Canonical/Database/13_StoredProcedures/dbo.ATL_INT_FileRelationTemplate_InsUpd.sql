SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[ATL_INT_FileRelationTemplate_InsUpd]
(
    @ID              bigint,
    @Id_FK_IdField   bigint,
    @Id_FK_IdFile    bigint,
	@IgnoreField     bit,
	@ValidateField   bit,
	@UpdateField     bit,
	@KeyField        bit,
	@Position        int,
	@Status          bit,
	@DtReferen       datetime,
	@CheckBox        bit,
	@UserModif       varchar(20),
	@Admin           varchar(50),
	@Unit            varchar(3),
	@AX_GRUPO        varchar(30),
	@Responsavel     varchar(20), 
	@DTVersion       datetime,
	@FK_IdClient     varchar(20)
)
AS
BEGIN
	BEGIN TRY
		Declare @ID_New as bigint;
			BEGIN
				SET @ID_New =(SELECT ISNULL(MAX(ID),0) FROM atl_int.dbo.LayoutRelationFieldFile 
							   WHERE Id_FK_IdField = @Id_FK_IdField AND
									 Id_FK_IdFile  = @Id_FK_IdFile  AND
									 FK_IdClient   = @FK_IdClient)
				IF @ID_New = 0
					begin
					   Insert into atl_int.dbo.LayoutRelationFieldFile
					   (
							Id_FK_IdField, Id_FK_IdFile, ValidateField,IgnoreField,UpdateField,KeyField,Position, 
							Status,DtReferen,UserModif,Admin,Unit,AX_GRUPO,Responsavel,
							DTVersion,CheckBox,FK_IdClient
					   )
					   Values
					   (
							@Id_FK_IdField, @Id_FK_IdFile, @ValidateField, @IgnoreField,@UpdateField,@KeyField,@Position, 
							@Status, @DtReferen,@UserModif,@Admin,@Unit,@AX_GRUPO,@Responsavel,
							@DTVersion,@CheckBox,@FK_IdClient
					   )
					   set @ID_New = @@IDENTITY
				   end
				ELSE
					begin
					   Update atl_int.dbo.LayoutRelationFieldFile set
							  Id_FK_IdField=@Id_FK_IdField, Id_FK_IdFile=@Id_FK_IdFile, 
							  IgnoreField=@IgnoreField,     ValidateField=@ValidateField,
							  UpdateField=@UpdateField,     KeyField=@KeyField, 
							  Position=@Position,           Status=@Status,
							  DtReferen=@DtReferen,         UserModif=@UserModif,
							  Admin=@Admin,                 Unit=@Unit,
							  AX_GRUPO=@AX_GRUPO,           Responsavel=@Responsavel,
							  DTVersion=@DTVersion,         CheckBox=@CheckBox,
							  FK_IdClient=@FK_IdClient
					   WHERE ID = @ID_NEW
				   end
		END	

			--SELECT MAX(ID) as Retorno FROM LayoutFile_Template;
			Select @ID_New as Retorno;

		COMMIT TRAN
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_MESSAGE() as Retorno;
	END CATCH	
END

GO
