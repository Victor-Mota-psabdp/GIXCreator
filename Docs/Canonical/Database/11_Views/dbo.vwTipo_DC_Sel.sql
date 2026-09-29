SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_DC
CREATE VIEW [dbo].[vwTipo_DC_Sel]
AS

select 
	Cd_Tp_DC		[Code],
	Descricao_TP_DC		[DC Type Name],
	Ativo			[Enabled],
	T.Cd_Usuario	[User Code],
	U.Nome_Usuario	[User Name],
	dt_ins			[Insert Date]
from Tipo_DC T with(nolock)
	LEFT join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
where
	ativo = 1

GO
