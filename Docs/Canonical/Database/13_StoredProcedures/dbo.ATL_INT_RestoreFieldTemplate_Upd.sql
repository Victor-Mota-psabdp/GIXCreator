SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[ATL_INT_RestoreFieldTemplate_Upd]
 	@XDTVersion   varchar(19)
AS
BEGIN
 
	Update tab1
	Set tab1.IgnoreField = tab2.IgnoreField,
		tab1.ValidateField = tab2.ValidateField,
		tab1.UpdateField = tab2.UpdateField,
		tab1.KeyField = tab2.KeyField,
		tab1.Position = tab2.Position,
		tab1.Status = tab2.Status,
	    tab1.DTReferen = tab2.DTReferen,
		tab1.UserModif = tab2.UserModif,
		tab1.DTVersion = tab2.DTVersion,
		tab1.FK_IdClient = tab2.FK_IdClient
    From ATL_INT.DBO.LayoutRelationFieldFile tab1
	Inner Join ATL_INT.DBO.LayoutRelationFieldFileHist tab2
	On tab1.Id_FK_IdFile = tab2.Id_FK_IdFile And
	   tab1.Id_FK_IdField = tab2.Id_FK_IdField 
	Where 
	   CONVERT(VARCHAR(10),tab2.DTVersion,110) + ' ' + CONVERT(VARCHAR(5),tab2.DTVersion,108) =
   	   @XDTVersion
        
END

GO
