SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vwRecinto_Aduaneiro_Sel]
AS

select 
	T.ID		[Code],
	T.Cd_Recinto	[Customs Area Code],
	T.Nome_Recinto	[Customs Area Name],
	T.Cd_local		[Place Code],
	L.Nome_local	[Place Name],
	T.Ativo			[Enabled],
	T.Cd_Usuario	[User Code],
	U.Nome_Usuario	[User Name],
	T.dt_ins			[Insert Date]
		
from Recinto_Aduaneiro T with(nolock)
	left join Localidade L with(nolock) on L.Cd_local=T.Cd_local
	join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
--where
--	ativo = 1			


GO
