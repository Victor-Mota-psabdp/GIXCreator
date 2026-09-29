SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[vwSolicitacao_LI]
as

select SLI.Num_Solicitacao	,
Dt_Solicitacao	,
ID_Tipo_LI	,
Cd_Usuario_Req	,
Cd_Usuario_Oper	,
Num_LI	,
Dt_LI	,
Dt_Aut_Embarque	,
Dt_Deferimento	,
Dt_Vencimento	,
Num_Proc	,
Protocolo_Transmissao	,
Motivo	,
Obs_LI	,
Cd_Fabricante	,
ID_Status	,
Dt_Requerimento	,
Num_Requerimento	,
Cd_Produto	,
ID_NCM	,
Qty	,
Peso_Bruto	,
Peso_Liquido	,
Cd_Tp_Moeda	,
Preco_Unit	


 from Solicitacao_LI SLI
Join Solicitacao_LI_Produto SLIP on SLIP.Num_Solicitacao = SLI.Num_Solicitacao 
where ID_Status not in (8,7,11,12)


GO
