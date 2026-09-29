SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[ATL_INT_FileRelationTemplateHistSel_InsUpd]
(
    @ID            bigint,
    @Id_FK_IdField bigint,
    @Id_FK_IdFile  bigint,
	@IgnoreField   bit,
	@ValidateField bit,
	@UpdateField   bit,
	@KeyField      bit,
	@Position      int,
	@Status        bit,
	@DtReferen     datetime,
	@CheckBox      bit,
	@UserModif     varchar(20),
	@Admin         varchar(50),
	@Unit          varchar(3),
	@AX_GRUPO      varchar(30),
	@Responsavel   varchar(20),
	@DTVersion     datetime,
	@FK_IdClient   varchar(20)
)
AS
BEGIN
	 Insert into ATL_int.dbo.LayoutRelationFieldFileHist 
	(Id_FK_IdField,  Id_FK_IdFile,  ValidateField,  IgnoreField,  UpdateField,   KeyField,  Position,     Status,  DtReferen,  CheckBox,
	 UserModif,      Admin,         Unit,           AX_GRUPO,     Responsavel,   DTVersion, FK_IdClient )  Values
	(@Id_FK_IdField, @Id_FK_IdFile, @ValidateField, @IgnoreField, @UpdateField,  @KeyField, @Position,    @Status, @DtReferen, @CheckBox,
	 @UserModif,     @Admin,        @Unit,          @AX_GRUPO,    @Responsavel,  @DTVersion, @FK_IdClient)

END

GO
