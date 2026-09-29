SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwATL_Type_Doc_Received_By_Email]
AS
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


GO
