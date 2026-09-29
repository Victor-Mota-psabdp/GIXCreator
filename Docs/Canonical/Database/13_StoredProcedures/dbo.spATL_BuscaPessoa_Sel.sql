SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spATL_BuscaPessoa_Sel] --'0',''
@Cd_Pes varchar(10),
@Apelido varchar(20)
as

IF @Apelido is not NULL and @Apelido <> ''
	Begin
		SELECT Cd_Pes FROM Pessoa with(nolock) where Apelido = @Apelido and Desat_Pes = 'N'
	End
Else
	Begin
		SELECT Apelido FROM Pessoa with(nolock) where Cd_Pes = @Cd_Pes and Desat_Pes = 'N'
	End






GO
