SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Grupo_Acesso
--alter table [dbo].[Grupo_Acesso] add [Leitura] [char](1) NULL
--alter table [dbo].[Grupo_Acesso] add [Gravacao] [char](1) NULL
--alter table [dbo].[Grupo_Acesso] add [Exclusao] [char](1) NULL

CREATE Procedure [dbo].[spATL_Grupo_Acesso_Del]
(	
	@Cd_Tela		varchar(3),
	@Cd_Pes_Grupo	varchar(10)
	
)
as

	BEGIN
		delete Grupo_Acesso where Cd_Tela= @Cd_Tela AND Cd_Pes_Grupo = @Cd_Pes_Grupo
	End

GO
