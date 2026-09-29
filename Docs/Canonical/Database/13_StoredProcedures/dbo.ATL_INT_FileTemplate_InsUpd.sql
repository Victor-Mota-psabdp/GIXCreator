SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[ATL_INT_FileTemplate_InsUpd]
(
    @ID              bigint,
	@PK_Name         varchar(20),
	@Status          bit,
    @DateCreate      datetime,
	@DateUpdate      datetime,
    @FK_IdClient     varchar(20),
	@Action          bit,
	@TypeFile        varchar(10),
	@DelimiterChar   nchar(1),
	@FinalLineChar   nchar(1),
	@StartData       int,
    @CheckBox        bit,
	@UserModif       varchar(20),
	@Admin           varchar(50),
	@Unit            varchar(3),
	@AX_GRUPO        varchar(30),
	@Responsavel     varchar(20)
)

AS
BEGIN
	BEGIN TRY
		Declare @ID_New as bigint;
		BEGIN
		    SET @ID_New =(SELECT ID FROM ATL_INT.DBO.LayoutFile_Template where ID = @ID)
			IF @ID_New IS NULL
				begin
					   Insert into ATL_INT.DBO.LayoutFile_Template
					   (
							PK_Name, Status,DateCreate, DateUpdate,FK_IdClient, Action,TypeFile,DelimiterChar,FinalLineChar,
							StartData,
							CheckBox, UserModif, Admin,Unit,AX_GRUPO,Responsavel
					   )
					   Values
					   (
							@PK_Name,@Status,@DateCreate,@DateUpdate, @FK_IdClient, @Action, @TypeFile,@DelimiterChar,@FinalLineChar,
							@StartData,
							@CheckBox,@UserModif, @Admin, @Unit, @AX_GRUPO,@Responsavel
					   )
					   set @ID_New = @@IDENTITY
				  End
			ELSE
				begin
				   Update ATL_INT.DBO.LayoutFile_Template set
						  PK_Name=@PK_Name, Status=@Status, DateCreate=@DateCreate, DateUpdate=@DateUpdate, FK_IdClient=@FK_IdClient,
						  Action=@Action, 
			 			  TypeFile=@TypeFile, DelimiterChar=@DelimiterChar, FinalLineChar=@FinalLineChar, StartData=@StartData,
						  CheckBox=@CheckBox, UserModif=@UserModif, Admin=@Admin, Unit=@Unit, 
						  AX_GRUPO=@AX_GRUPO, Responsavel=@Responsavel
				   WHERE ID = @ID_NEW
			   End

			END	

			--SELECT ID AS Retorno FROM LayoutFile_Template WHERE PK_Name = @PK_Name ;
			Select @ID_New as Retorno;	

		COMMIT TRAN
	END TRY

	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_MESSAGE() as Retorno;

	END CATCH	

END

GO
