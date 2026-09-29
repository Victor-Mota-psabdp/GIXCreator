SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vw_RetificacaoDI_Sel] 

AS
	
select DISTINCT
	R.NUM_PROC				[1_JOB],
	R.DT_SOLICITACAO		[2_Dt.Registro],
	SOL.Nome_Usuario		[3_Requester],
	R.NUM_DI				[4_DI],
	DESP.Nome_Usuario		[5_Despachante],
	R.NR_RETIFICACAO		[6_Numero do Processo Digital],
	R.DT_RETIFICACAO		[7_Data do Protocolo],
	TR.NOME_TP_RET			[8_Tipo de Retificação],
	TU.Nome_TP_Usuario_RET	[9_Solicitado por:],
	R.VL_TOTAL_IMPOSTOS		[10_Valor Total dos Impostos na DI Original],
	R.VL_TOTAL_IMPOSTOS_RECOLHIDOS [11_Valor dos Impostos ou Multas Recolhidos],
	R.NOME_TAX_CLIENTE		[12_Responsavel no TAX cliente],	
	NOME_ITO_CLIENTE		[13_Responsavel no ITO cliente],
	--QTDE_ADICOES_DI
	--QTDE_ADICOES_RETIFICADA
	--ID_STATUS
	--DT_ULTIMA
	--ATIVO
	TS.Status_Descricao		[14_Status]	
from [Retificacao_DI] R
	left join usuario SOL on SOL.Cd_Usuario = R.CD_SOLICITANTE
	left join usuario DESP on DESP.Cd_Usuario = R.CD_DESPACHANTE
	left join Tipo_RetificacaoDI TR on TR.ID_TP_RET = R.ID_TP_RET
	left join Tipo_Usuario_Retificacao TU on TU.ID_TP_Usuario_RET = R.ID_TP_RET
	left join Tipo_Status_Retificacao TS on TS.ID_Status = R.ID_STATUS
	
	


GO
