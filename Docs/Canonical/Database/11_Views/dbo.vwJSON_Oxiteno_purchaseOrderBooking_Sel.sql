SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwJSON_Oxiteno_purchaseOrderBooking_Sel]
AS

select 
	S.ID_purchaseOrderBooking [Internal Code],
	S.ref_oxiteno,
	S.numero_viagem,
	S.navio,
	S.etd,
	S.eta,
	S.Num_Proc				[JOB],			
	S.dt_ins			[Insert Date],
	S.Dt_Sent			[Sent Date],	
	S.atd,
	S.confirmacao_docs
	,S.Message	
from 
	ATL_INT.dbo.JSON_Oxiteno_purchaseOrderBooking S with(nolock)	
	

GO
