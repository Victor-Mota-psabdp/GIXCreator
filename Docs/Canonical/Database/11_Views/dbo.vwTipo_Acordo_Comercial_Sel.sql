SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwTipo_Acordo_Comercial_Sel]
AS

select 
	ID_TP_AC		[Code],
	NOME_TP_AC		[Agreement Name],
	Ativo			[Enabled],
	T.Cd_Usuario	[User Code],
	U.Nome_Usuario	[User Name],
	dt_ins			[Insert Date]
from Tipo_Acordo_Comercial T with(nolock)
	join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
where
	ativo = 1
			
--select 
--	ID_TP_AC [Code], NOME_TP_AC [Nome Acordo],Ativo,Nome_Usuario,dt_ins [Data] 
--from Tipo_Acordo_Comercial T with(nolock)
--	join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
--where
--	ativo = 1

GO
