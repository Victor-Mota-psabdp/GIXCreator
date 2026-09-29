SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwATLDN_Usuario_Sel]
AS
/*
select * from [dbo].[vwATLDN_Usuario_Sel]
*/

SELECT 
	Cd_Usuario				[Code],
	Nome_Usuario			[Complete Name],
	'********************'	[Password],
	Cargo					[Position],
	US.Cd_Area				[Department Code], 
	AR.nome_area			[Department],
	GR.ID_Tp_GR_Usuario		[Group Code],-- Alessandra 11/06/2020
	Grupo					[Group],
	US.Cd_Idioma			[Language Code],
	ID.Nome_Idioma			[Language],
	US.Cd_Nivel				[Level Code],
	NV.Tipo_Nivel			[Level],
	Fone					[Phone Number],
	Email					[E-Mail],
	ADDomain				[AD Domain], -- Alessandra 11/06/2020
	ADUserName				[AD User Name], -- Alessandra 11/06/2020	
	Ck_Ativo				
FROM dbo.Usuario US  (nolock) 
LEFT OUTER JOIN dbo.Area AR  (nolock) 
	ON AR.Cd_Area = US.Cd_Area 
LEFT OUTER JOIN dbo.Idioma ID  (nolock) 
	ON ID.Cd_Idioma = US.Cd_Idioma 
LEFT OUTER JOIN dbo.Nivel NV  (nolock) 
	ON US.Cd_Nivel = NV.Cd_Nivel
left join Tipo_Grupo_Usuario GR (nolock)
	on US.Grupo = GR.Nome_Tp_GR_Usuario 




GO
