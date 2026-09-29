SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwTipo_Remessa_Boleto_Sel]
AS

select 
	Id_Tp_Remessa		[Code],
	Nome_Tp_Remessa		[Remessa Type Name],
	Ativo				[Enabled],
	T.Cd_Usuario		[User Code],
	U.Nome_Usuario		[User Name],
	dt_ins				[Insert Date]
from Tipo_Remessa_Boleto T with(nolock)
	join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario

GO
