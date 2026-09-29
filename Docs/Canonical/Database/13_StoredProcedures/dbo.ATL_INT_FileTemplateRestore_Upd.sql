SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[ATL_INT_FileTemplateRestore_Upd]
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
	Update 
		ATL_int.dbo.LayoutFile_Template 
	set
  	    PK_Name=@PK_Name, Status=@Status, DateCreate=@DateCreate, DateUpdate=@DateUpdate, FK_IdClient=@FK_IdClient, Action=@Action, 
	   	TypeFile=@TypeFile, DelimiterChar=@DelimiterChar, FinalLineChar=@FinalLineChar, StartData=@StartData,
		CheckBox=@CheckBox, UserModif=@UserModif, Admin=@Admin, Unit=@Unit, AX_GRUPO=@AX_GRUPO, Responsavel=@Responsavel
    WHERE
		FK_IdClient=@FK_IdClient AND
		PK_Name=@PK_Name
END

GO
