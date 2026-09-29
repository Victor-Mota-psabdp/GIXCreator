SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vwJSON_Oxiteno_purchaseOrderContainer_Sel]
AS

select 
	S.ID_purchaseOrderContainer [Internal Code],
	S.ref_oxiteno,			
	S.container,
	S.free_time,
	S.limite_arm_porto,
	S.entrada_armazem_ext,
	S.saida_armazem_ext,
	S.entrega_fabrica,
	S.saida,
	S.devolucao,
	S.local_entrega_vazio,
	S.Num_Proc				[JOB],
	left(S.Message,2000)				[Message],
	S.dt_ins			[Insert Date],
	S.Dt_Sent			[Sent Date],
	S.valor_demurrage
from 
	ATL_INT.dbo.JSON_Oxiteno_purchaseOrderContainer S with(nolock)	

GO
