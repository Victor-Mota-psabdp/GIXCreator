SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spATL_Type_Doc_Received_By_Email_Sel] 
(
	@ID bigint,
	@From varchar(200),
	@Subject varchar(200),
	@Doc_Extension varchar(200),
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
			ID						[ID],
			DI.[From]				[From],
			DI.[Subject]			[Subject],
			DI.Doc_Extension		[Doc_Extension],
			DI.Destination_Folder	[Destination],
			dr.Cd_Tipo				[Type Code],
			dr.Nome_Tipo			[Type Name],
			Emails					[Sent To:],
			DI.Cd_Usuario			[User Code],
			U.Nome_Usuario			[User Name],
			DI.Dt_ins				[Insert Date],
			DI.Ativo				[Active]
			,DI.Doc_Full_Name		[Doc_Full_Name]
		FROM ATL_INT.[dbo].Type_Doc_Received_By_Email DI WITH (NOLOCK)
			LEFT JOIN ATLANTIS.dbo.Usuario U WITH (NOLOCK) ON U.Cd_Usuario = DI.Cd_Usuario
			LEFT JOIN ATL_INT.[dbo].Type_Doc_Received_By_Email_Rules DR WITH (NOLOCK) ON dr.Cd_Tipo = DI.Cd_Tipo
	END

IF @Tipo = 'B'
	BEGIN
		SELECT
			ID						[ID],
			DI.[From]				[From],
			DI.[Subject]			[Subject],
			DI.Doc_Extension		[Doc_Extension],
			DI.Destination_Folder	[Destination],
			dr.Cd_Tipo				[Type Code],
			dr.Nome_Tipo			[Type Name],
			Emails					[Sent To:],
			DI.Cd_Usuario			[User Code],
			U.Nome_Usuario			[User Name],
			DI.Dt_ins				[Insert Date],
			DI.Ativo				[Active]
			,DI.Doc_Full_Name		[Doc_Full_Name]
		FROM ATL_INT.[dbo].Type_Doc_Received_By_Email DI WITH (NOLOCK)
			LEFT JOIN ATLANTIS.dbo.Usuario U WITH (NOLOCK) ON U.Cd_Usuario = DI.Cd_Usuario
			LEFT JOIN ATL_INT.[dbo].Type_Doc_Received_By_Email_Rules DR WITH (NOLOCK) ON dr.Cd_Tipo = DI.Cd_Tipo
		WHERE 
			DI.Ativo = 1		
	END


IF @Tipo = 'C' OR @Tipo = 'D'
	BEGIN
		SELECT
			ID						[ID],
			DI.[From]				[From],
			DI.[Subject]			[Subject],
			DI.Doc_Extension		[Doc_Extension],
			DI.Destination_Folder	[Destination],
			dr.Cd_Tipo				[Type Code],
			dr.Nome_Tipo			[Type Name],
			Emails					[Sent To:],
			DI.Cd_Usuario			[User Code],
			U.Nome_Usuario			[User Name],
			DI.Dt_ins				[Insert Date],
			DI.Ativo				[Active]
			,DI.Doc_Full_Name		[Doc_Full_Name]
		FROM ATL_INT.[dbo].Type_Doc_Received_By_Email DI WITH (NOLOCK)
			LEFT JOIN ATLANTIS.dbo.Usuario U WITH (NOLOCK) ON U.Cd_Usuario = DI.Cd_Usuario
			LEFT JOIN ATL_INT.[dbo].Type_Doc_Received_By_Email_Rules DR WITH (NOLOCK) ON dr.Cd_Tipo = DI.Cd_Tipo
		WHERE
			DI.ID = @ID
	END

IF @Tipo = 'N' OR @Tipo = 'O'
	BEGIN
		SELECT
			ID						[ID],
			DI.[From]				[From],
			DI.[Subject]			[Subject],
			DI.Doc_Extension		[Doc_Extension],
			DI.Destination_Folder	[Destination],
			dr.Cd_Tipo				[Type Code],
			dr.Nome_Tipo			[Type Name],
			Emails					[Sent To:],
			DI.Cd_Usuario			[User Code],
			U.Nome_Usuario			[User Name],
			DI.Dt_ins				[Insert Date],
			DI.Ativo				[Active]
			,DI.Doc_Full_Name		[Doc_Full_Name]
		FROM ATL_INT.[dbo].Type_Doc_Received_By_Email DI WITH (NOLOCK)
			LEFT JOIN ATLANTIS.dbo.Usuario U WITH (NOLOCK) ON U.Cd_Usuario = DI.Cd_Usuario
			LEFT JOIN ATL_INT.[dbo].Type_Doc_Received_By_Email_Rules DR WITH (NOLOCK) ON dr.Cd_Tipo = DI.Cd_Tipo
		WHERE
			[Doc_Extension] = @Doc_Extension
	END

--IF @Tipo = 'Z' --OR @Tipo = 'O'
--	BEGIN
--		SELECT
--			ID						[ID],
--			DI.[From]				[From],
--			DI.[Subject]			[Subject],
--			DI.Doc_Extension		[Doc_Extension],
--			DI.Destination_Folder	[Destination],
--			dr.Cd_Tipo				[Type Code],
--			dr.Nome_Tipo			[Type Name],
--			Emails					[Sent To:],
--			DI.Cd_Usuario			[User Code],
--			U.Nome_Usuario			[User Name],
--			DI.Dt_ins				[Insert Date],
--			DI.Ativo				[Active]
--			,DI.Doc_Full_Name		[Doc_Full_Name]
--		FROM ATL_INT.[dbo].Type_Doc_Received_By_Email DI WITH (NOLOCK)
--			LEFT JOIN ATLANTIS.dbo.Usuario U WITH (NOLOCK) ON U.Cd_Usuario = DI.Cd_Usuario
--			LEFT JOIN ATL_INT.[dbo].Type_Doc_Received_By_Email_Rules DR WITH (NOLOCK) ON dr.Cd_Tipo = DI.Cd_Tipo
--		WHERE
--			[Doc_Extension] = @Doc_Extension and ID <> @ID	

--END

GO
