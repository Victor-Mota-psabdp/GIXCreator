SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwTermo_Pagamento_Sel]
AS
select Cd_Termo AS [Code],Descricao_Termo AS [Type Payments], 
		Dias [Days],Dt_Base [Base Date],
		--Mapa_ATL [ATL Map],
		Dt_Ins [Insert Date],
		Ativo [Enabled],
		T.Cd_Usuario [User Code], 
		U.Nome_Usuario [User Name]
		from Termo_Pagamento T with(nolock)
		left join usuario U with(nolock) on U.Cd_Usuario = T.Cd_Usuario

GO
