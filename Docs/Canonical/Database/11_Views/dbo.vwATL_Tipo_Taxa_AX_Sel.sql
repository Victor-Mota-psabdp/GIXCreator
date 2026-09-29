SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Taxa_AX
CREATE VIEW [dbo].[vwATL_Tipo_Taxa_AX_Sel]
AS
	select Cd_Charge_AX [Code], Descricao_Ingles, CC_Custo,
			CC_Receita, Descricao_Local,CD_Charge_AX_PT,Codigo_Imposto,Codidgo_Imposto_Venda
		from 
			Tipo_Taxa_AX with(nolock)

GO
