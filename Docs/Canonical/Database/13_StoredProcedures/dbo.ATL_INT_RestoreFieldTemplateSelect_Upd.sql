SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[ATL_INT_RestoreFieldTemplateSelect_Upd]
    @IgnoreField bit,
	@ValidateField bit,
	@UpdateField bit,
	@KeyField bit,
	@Position int,
	@Status bit,
	@DTReferen datetime,
	@UserModif varchar(40),
	@DTVersion datetime,
	@Id_FK_IdFile bigint,
	@Id_FK_IdField bigint
AS
BEGIN
 
	Update ATL_INT.DBO.LayoutRelationFieldFile
	Set IgnoreField=@IgnoreField,
		ValidateField=@ValidateField,
		UpdateField=@UpdateField,
		KeyField=@KeyField,
		Position=@Position,
		Status=@Status,
	    DTReferen=@DTReferen,
		UserModif=@UserModif,
		DTVersion=@DTVersion
   	Where 
	Id_FK_IdFile=@Id_FK_IdFile And
	Id_FK_IdField=@Id_FK_IdField 
        
END

GO
