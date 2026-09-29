SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[ATL_INT_GridTemplateMaster_Sel]
    @codcli    nvarchar(20),
   	@idlayout  bigint,
	@tptable   int
AS
BEGIN

Declare @instruc    nvarchar(2000),
        @codcli2    nvarchar(20),
     	@idlayout2  bigint ,
		@tptable2   int

Set @instruc = N'Select Distinct Files.ID,            Files.PK_Name,       Files.Status,     Files.DateCreate, Files.FK_IdClient, Files.Action, Files.TypeFile,        
	                             Files.DelimiterChar, Files.FinalLineChar, Files.StartData,  Pes.Apelido,      Files.UserModif,      Files.Admin,  Files.Unit,   
				   		         Files.AX_GRUPO,	  Files.Responsavel,   Files.DateUpdate, Files.CheckBox ';

IF (@tptable = 1)
   Begin
      Set  @instruc = @instruc + N'From ATL_INT.DBO.LayoutFile_Template Files left Join ATL_INT.DBO.LayoutRelationFieldFile Relation '; 
   End
ELSE				 
   Begin	
      Set  @instruc = @instruc + N'From ATL_INT.DBO.LayoutFile_Template Files left Join ATL_INT.DBO.LayoutRelationFieldFileHist Relation '; 
   End

 --set @instruc = @instruc + N' on Relation.Id_FK_IdFile = Files.ID Left Join Atlantis.dbo.Grupo Grp On Relation.FK_IdClient = Grp.Cd_Pes_Grupo Left Join Atlantis.dbo.Pessoa Pes On Grp.Cd_Pes_Grupo = Pes.Cd_Pes ';

 set @instruc = @instruc + N' On Relation.Id_FK_IdFile = Files.ID Left Join Atlantis.dbo.Grupo Grp On Relation.FK_IdClient = Grp.Cd_Pes_Grupo inner Join Atlantis.dbo.Pessoa Pes On Pes.Cd_Pes = Files.FK_IdClient left Join Atlantis.dbo.Grupo Grp2 On Grp2.Cd_Pes_Grupo = Pes.Cd_Pes ';




IF ( (@codcli <> '') AND @idlayout <> 0 )
   Begin
      Set @instruc = @instruc + N' Where Files.FK_IdClient = @codcli2 and Files.ID = @idlayout2 ';
   End
ELSE
   Begin
	  IF ( (@codcli is null or @codcli = '') AND @idlayout <> 0)
		   Begin
		   Set @instruc = @instruc + N' Where Files.ID = @idlayout2'; 
  	  End
	 
	  IF ( @codcli <> '' AND @idlayout = 0 )
		  Begin
		    Set @instruc = @instruc + N' Where Files.FK_IdClient = @codcli2';
		  End 
		
   End 

Execute sp_executesql @instruc, N'@codcli2 nvarchar(20), @idlayout2 bigint',  @codcli2=@codcli, @idlayout2=@idlayout;

END

GO
