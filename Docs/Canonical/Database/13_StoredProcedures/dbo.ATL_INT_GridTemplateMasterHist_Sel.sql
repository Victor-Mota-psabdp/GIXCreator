SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[ATL_INT_GridTemplateMasterHist_Sel]
    @codcli    nvarchar(20),
   	@idlayout  bigint,
	@tptable   int
AS
BEGIN

Declare @instruc    nvarchar(2000),
        @codcli2    nvarchar(20),
     	@idlayout2  bigint ,
		@tptable2   int

Set @instruc = N'Select Distinct a.PK_Name,       a.Status,        c.DateCreate,  b.FK_IdClient, c.Action,    c.TypeFile,
                                 c.DelimiterChar, c.FinalLineChar, a.DateUpdate,  c.StartData,   Pes.Apelido, c.UserModif,  	  
								 c.Unit,          c.AX_GRUPO,	   c.Responsavel, c.DateUpdate,  c.CheckBox
                 from            ATL_INT.DBO.LayoutFile_TemplateHist a Inner Join ATL_INT.DBO.LayoutRelationFieldFileHist b
                 On              b.FK_IdClient = a.FK_IdClient 
                 Inner join   ATL_INT.DBO.LayoutFile_Template c    On  c.PK_Name        = a.PK_Name
                 Inner Join   Atlantis.dbo.Grupo  Grp  On  b.FK_IdClient    = Grp.Cd_Pes_Grupo 
                 inner Join   Atlantis.dbo.Pessoa Pes  On  Grp.Cd_Pes_Grupo = Pes.Cd_Pes '; 

IF ( @codcli is not null AND @idlayout <> 0 )
   Begin
      Set @instruc = @instruc + N'Where b.FK_IdClient = @codcli2 and c.ID = @idlayout2 ';
   End
ELSE
   Begin
	  IF ( @codcli is null AND @idlayout <> 0)
		   Begin
		   Set @instruc = @instruc + N'Where c.ID = @idlayout2 '; 
  	  End
	  IF ( @codcli <> '' AND @idlayout = 0 )
		  Begin
		    Set @instruc = @instruc + N'Where b.FK_IdClient = @codcli2 ';
		  End 
   End 

Execute sp_executesql @instruc, N'@codcli2 nvarchar(20), @idlayout2 bigint',  @codcli2=@codcli, @idlayout2=@idlayout;

END

GO
