SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwTipo_Lancamento_RF_Sel]
AS
	select 
		Cd_Tipo_Lanc			[Code],
		Descricao_Tp_Lancamento	[Register Type],
		Ativo				[Enabled] 
	from 
		Tipo_Lancamento_RF with(nolock)



GO
