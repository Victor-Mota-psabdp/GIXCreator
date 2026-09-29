SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Tipo_Doc_DMS
CREATE VIEW [dbo].[vwTipo_Doc_DMS_Sel]
AS
	select
		T.ID_TP_DC				[Code],
		T.DMS_Code				[DMS Code],
		T.Document_Type_Name	[Document Type Name],
		T.Role					[Role],
		T.Comment				[Comment],
		T.ID_DC					[Doc Client Type Code],
		TD.Nome_DC				[Doc Client Type Name],
		T.Ativo					[Enabled],
		T.Cd_Usuario			[User Code],
		U.Nome_Usuario			[User Name],
		T.dt_ins				[Insert Date]			
	from Tipo_Doc_DMS T with(nolock)
		LEFT join TIPO_DOC_CLIENTE TD with(nolock) on TD.ID_DC=T.ID_DC
		join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario

GO
