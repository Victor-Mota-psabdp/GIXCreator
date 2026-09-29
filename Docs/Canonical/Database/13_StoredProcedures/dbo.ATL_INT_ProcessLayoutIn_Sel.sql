SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--nao sei pq estava faltando o Field.FieldMapClass7 - cadu 2025-07-14
CREATE Procedure [dbo].[ATL_INT_ProcessLayoutIn_Sel]
(
    @codcli    nvarchar(20),
   	@idlayout  bigint
)

AS
BEGIN

Declare @instruc    nvarchar(2000),
        @codcli2    nvarchar(20),
     	@idlayout2  bigint


Set @instruc = N'Select Relation.ID,     Field.PK_Code,       Field.Name,           Field.TypeField,       Relation.ValidateField, Relation.IgnoreField, Relation.UpdateField, Relation.KeyField, 
                        Field.Path,      Field.ID as IdField, Relation.Position,    Relation.Id_FK_IdFile, Relation.DtReferen,     Relation.CheckBox,    Relation.Status,      Relation.UserModif,   
						Relation.Admin,  Relation.Unit,       Relation.AX_GRUPO,    Relation.Responsavel,  Relation.DTVersion,     Files.Action,         Files.TypeFile,       Files.StartData,
						Field.ClassName, Field.Parameter1,    Field.FieldMapClass,  Field.Cd_Tipo,         Field.FieldMapClass2,   Field.FieldMapClass3, Field.FieldMapClass4, Field.FieldMapClass5,
						Field.FieldMapClass6,Field.FieldMapClass7
                 From ATL_INT.dbo.LayoutField_Template Field Left  Join ATL_INT.dbo.LayoutRelationFieldFile Relation on Field.ID = Relation.Id_FK_IdField 
				 Right Join ATL_INT.dbo.LayoutFile_Template  Files  on Files.ID = Relation.Id_FK_IdFile ';

IF ( @codcli is null AND @idlayout <> 0)
Begin
   Set @instruc = @instruc + N'Where Relation.Id_FK_IdFile = @idlayout2 '; 
End
IF ( @codcli is not null AND @idlayout = 0 )
Begin
   Set @instruc = @instruc + N'Where Relation.FK_IdClient = @codcli2 ';
End 
IF ( @codcli is not null AND @idlayout <> 0 )
Begin
   Set @instruc = @instruc + N'Where Relation.FK_IdClient = @codcli2 and Relation.Id_FK_IdFile = @idlayout2 ';
End

Set @instruc = @instruc + N'Order by Relation.Position ';

Execute sp_executesql @instruc, N'@codcli2 nvarchar(20), @idlayout2 bigint',  @codcli2=@codcli,@idlayout2=@idlayout ;

END

GO
