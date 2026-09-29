SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[ATL_INT_FileTemplateHist_InsUpd]
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
	Declare @ID_New as bigint
	BEGIN
	   SET @ID_New = (SELECT COUNT(*) FROM ATL_int.dbo.LayoutFile_TemplateHist 
	                  WHERE CONVERT(VARCHAR(10),DateUpdate,110) = CONVERT(VARCHAR(10),@DateUpdate,110) AND 
	                  PK_Name=@PK_Name AND
					  FK_IdClient=@FK_IdClient)
		IF @ID_New = 0
			begin	
			  Insert into ATL_int.dbo.LayoutFile_TemplateHist
			  (
				  PK_Name,Status, DateCreate,DateUpdate, FK_IdClient, Action,TypeFile, DelimiterChar, FinalLineChar,StartData,
		   		  CheckBox, UserModif, Admin,Unit, AX_GRUPO, Responsavel
			  )
			  Values
			  (
				  @PK_Name,@Status,@DateCreate,@DateUpdate,@FK_IdClient,@Action,@TypeFile,@DelimiterChar,@FinalLineChar,@StartData,
				  @CheckBox,@UserModif,@Admin,@Unit,@AX_GRUPO,@Responsavel
			  )
			end
        ELSE
			begin
				Update 
					ATL_int.dbo.LayoutFile_TemplateHist 
				set
					PK_Name=@PK_Name, Status=@Status, DateCreate=@DateCreate, DateUpdate=@DateUpdate, FK_IdClient=@FK_IdClient,
					Action=@Action, TypeFile=@TypeFile, DelimiterChar=@DelimiterChar, 
					FinalLineChar=@FinalLineChar, StartData=@StartData, CheckBox=@CheckBox, UserModif=@UserModif,
					Admin=@Admin, Unit=@Unit,  AX_GRUPO=@AX_GRUPO,  Responsavel=@Responsavel
				WHERE 
					CONVERT(VARCHAR(10),DateUpdate,110) = CONVERT(VARCHAR(10),@DateUpdate,110) AND 
					PK_Name=@PK_Name AND
					FK_IdClient=@FK_IdClient
			end
	END
END

GO
