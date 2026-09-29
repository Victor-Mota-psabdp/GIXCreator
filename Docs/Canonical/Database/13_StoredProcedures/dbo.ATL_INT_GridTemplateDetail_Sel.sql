SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[ATL_INT_GridTemplateDetail_Sel]
    @codcli    nvarchar(20),
   	@idlayout  bigint,
	@tptable   int

AS
BEGIN

Declare @instruc    nvarchar(2000),
        @codcli2    nvarchar(20),
     	@idlayout2  bigint,
		@tptable2   int,
		@column     nvarchar(20)


Set @instruc = N'Select Relation.ID, Field.PK_Code,  Field.Name, Field.TypeField, Relation.ValidateField, Relation.IgnoreField, Relation.UpdateField, Relation.KeyField, Field.Path,        Field.ID as IdField, 
                        Relation.Position,  Relation.Id_FK_IdFile, Relation.DtReferen, Relation.CheckBox, Relation.Status,        Relation.UserModif,   Relation.Admin,       Relation.Unit,     Relation.AX_GRUPO, Relation.Responsavel,
						Relation.DTVersion, Relation.FK_IdClient
                 From ATL_INT.DBO.LayoutField_Template Field Left  Join '
IF (@tptable = 1)
   Begin
      Set  @instruc = @instruc + N'ATL_INT.DBO.LayoutRelationFieldFile '; 
   End
ELSE				 
   Begin	
      Set  @instruc = @instruc + N'ATL_INT.DBO.LayoutRelationFieldFileHist '; 
   End


Set  @instruc = @instruc + N' Relation on Field.ID = Relation.Id_FK_IdField right Join ATL_INT.DBO.LayoutFile_Template Files on Files.ID = Relation.Id_FK_IdFile ';

IF ( @codcli is null AND @idlayout <> 0)
Begin
   Set @instruc = @instruc + N'Where Relation.Id_FK_IdFile = @idlayout2 '; 
End
IF ( @codcli is not null AND @idlayout = 0 )
Begin
   Set @instruc = @instruc + N'Where Relation.FK_IdClient =  @codcli2 ';
End 
IF ( @codcli is not null AND @idlayout <> 0 )
Begin
   Set @instruc = @instruc + N'Where Relation.FK_IdClient = @codcli2 and Relation.Id_FK_IdFile = @idlayout2 ';
End

Set @instruc = @instruc + N'Order by Relation.Id_FK_IdFile, Relation.Position ';

Execute sp_executesql @instruc, N'@codcli2 nvarchar(20), @idlayout2 bigint, @tptable2 int',  @codcli2=@codcli,@idlayout2=@idlayout,@tptable2=@tptable ;

END

GO
