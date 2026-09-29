SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[ATL_INT_GridTemplateField_Sel]
 
AS
BEGIN
 
Select Field.ID,   Field.PK_Code, Field.Name,Field.TypeField,Field.Path,Field.CheckBox
From  ATL_INT.dbo.LayoutField_Template Field;

END
GO
