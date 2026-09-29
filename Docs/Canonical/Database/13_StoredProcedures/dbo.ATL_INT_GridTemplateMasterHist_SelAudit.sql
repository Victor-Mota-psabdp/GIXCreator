SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[ATL_INT_GridTemplateMasterHist_SelAudit]
    @codcli    nvarchar(20),
   	@idlayout  bigint,
	@tptable   int
AS
BEGIN

Declare @instruc    nvarchar(2000),
        @codcli2    nvarchar(20),
     	@idlayout2  bigint ,
		@tptable2   int

Set @instruc = N'Select Distinct c.ID Code,            a.PK_Name Layout,       c.DateCreate, ';     
Set @instruc = @instruc + N'CONVERT(VARCHAR(10),a.DateUpdate,103)+';
Set @instruc = @instruc + N'SPACE(1)+';
Set @instruc = @instruc + N' SUBSTRING(CONVERT(VARCHAR(4),a.DateUpdate,108),1,4) as UpDated,           
                             a.Status,       b.FK_IdClient, c.Action,    c.TypeFile,
                             c.DelimiterChar, c.FinalLineChar, c.StartData,   Pes.Apelido,   c.UserModif,  	  
							 c.Unit,          c.AX_GRUPO,	   c.Responsavel, c.CheckBox   
               From   ATL_INT.DBO.LayoutFile_TemplateHist a Inner Join ATL_INT.DBO.LayoutRelationFieldFileHist b
               On     b.FK_IdClient = a.FK_IdClient 
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
