SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwATLDN_NCM_Sel]
AS
	--select Id_NCM [Code],NCM,Descricao_NCM[NCM Description] from NCM with(nolock)
	
	select 			
			N.NCM [NCM],
			N.NCM [NCM Code],
			Id_NCM [Code],
			Descricao_NCM[NCM Description],
			Alterado [Changed],Vencimento [Due Date],
			N.cd_usuario [User Code],
			U.nome_usuario	[User Name],
			DT_INS [Insert Date],
			Excecao [Exception]
		from NCM N with(nolock)
			left join Usuario U with(nolock) on U.cd_usuario = N.cd_usuario

GO
