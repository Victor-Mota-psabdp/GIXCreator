SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwJSON_Oxiteno_updateSalesOrders_Sel]
AS

select 
	S.ID_updateSalesOrders [Internal Code],
	S.cd_pedido,
	S.numero_pedido,
	S.Num_Proc				[JOB],	
	S.booking,
	S.numero_viagem,
	S.navio,
	S.conhec_transporte,
	S.terminal,
	S.etd,
	S.eta,
	S.deadline_draft,
	S.deadline_carga,

	S.dt_ins				[Insert Date],
	S.Dt_Sent				[Sent Date]	
from 
	ATL_INT.dbo.JSON_Oxiteno_updateSalesOrders S with(nolock)	
	

GO
