SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[spATL_Check_Routine_Sel] 
(
	@ID bigint,
	@Tipo char(1)
)

AS

  /*
  A, /// Todos os registros - Existentes
  B, /// Todos os registros - Ativos
  C, /// Busca pelo Codigo - Existentes
  D, /// Busca pelo Codigo - Ativos
  N, /// Busca pelo Nome - Existentes
  O /// Busca pelo Nome - Ativos
  Z /// Verifica Nome X Codigo
  
  */

IF @Tipo = 'A'
	BEGIN
		SELECT
			CR.[ID]						[ID],
			CR.[Routine_Name]			[Routine Name],
			CR.[Server]					[Server],
			CR.[Path]					[Path],
			CR.[SVN_Download]			[SVN Download],
			CR.[Notes]					[Notes],
			CR.[Enabled]				[Enabled],
			CR.Cd_Usuario				[User Code],
			U.Nome_Usuario				[User Name],
			CR.Dt_Ins					[Insert Date]
		FROM ATL_INT.[dbo].Check_Routine CR WITH (NOLOCK)
		LEFT JOIN ATLANTIS.dbo.Usuario U WITH (NOLOCK) ON U.Cd_Usuario = CR.Cd_Usuario
	END

IF @Tipo = 'B'
	BEGIN
		SELECT
			CR.[ID]						[ID],
			CR.[Routine_Name]			[Routine Name],
			CR.[Server]					[Server],
			CR.[Path]					[Path],
			CR.[SVN_Download]			[SVN Download],
			CR.[Notes]					[Notes],
			CR.[Enabled]				[Enabled],
			CR.[Cd_Usuario]				[User Code],
			U.[Nome_Usuario]			[User Name],
			CR.[Dt_Ins]					[Insert Date]
		FROM ATL_INT.[dbo].Check_Routine CR WITH (NOLOCK)
		LEFT JOIN ATLANTIS.dbo.Usuario U WITH (NOLOCK) ON U.Cd_Usuario = CR.Cd_Usuario
		WHERE 
			CR.[Enabled] = 1		
	END


IF @Tipo = 'C' OR @Tipo = 'D'
	BEGIN
		SELECT
			CR.[ID]						[ID],
			CR.[Routine_Name]			[Routine Name],
			CR.[Server]					[Server],
			CR.[Path]					[Path],
			CR.[SVN_Download]			[SVN Download],
			CR.[Notes]					[Notes],
			CR.[Enabled]				[Enabled],
			CR.[Cd_Usuario]				[User Code],
			U.[Nome_Usuario]			[User Name],
			CR.[Dt_Ins]					[Insert Date]
		FROM ATL_INT.[dbo].Check_Routine CR WITH (NOLOCK)
		LEFT JOIN ATLANTIS.dbo.Usuario U WITH (NOLOCK) ON U.Cd_Usuario = CR.Cd_Usuario
		WHERE 
			CR.[ID]	 = @ID	
	END

GO
