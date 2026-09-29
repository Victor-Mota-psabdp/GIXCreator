SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwTipo_Banco_Sel]
AS

	select 
		T.id_tp_banco			[Code],
		T.nome_tp_banco			[Bank Type Name],
		T.Nome_full_banco		[Bank Type Complete Name],
		T.Ativo					[Enabled],
		T.Cd_Usuario			[User Code],
		U.Nome_Usuario			[User Name],
		T.dt_ins				[Insert Date]	
	from Tipo_Banco T with(nolock)
		join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
	--where
	--	ativo = 1
			


GO
