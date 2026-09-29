SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwJSON_Oxiteno_purchaseOrderDesembaraco_Sel]
AS

select 
	S.ID_purchaseOrderDesembaraco [Internal Code],
	S.ref_oxiteno,			
	S.etd,
	S.eta,
	S.ata,
	S.presenca_carga,
	S.data_madeira,
	S.desembaraco,
	S.canal,
	S.liberacao_transp,
	S.atd,
	S.ci,
	S.pagamento_icms,
	S.Num_Proc				[JOB],			
	S.dt_ins			[Insert Date],
	S.Dt_Sent			[Sent Date],
	S.recebimento_docs,
	S.assinatura_laudo
	,S.Message
from 
	ATL_INT.dbo.JSON_Oxiteno_purchaseOrderDesembaraco S with(nolock)		

GO
