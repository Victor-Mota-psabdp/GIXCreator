SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwTipo_Documento_Sel]
AS

	select 
		Cd_Tp_Doc	[Code],
		Nome_Tp_Doc	[Document Type],
		Status		[Enabled] 
	from 
		Tipo_Documento with(nolock)
	--where
	--	ativo = 1
			


GO
