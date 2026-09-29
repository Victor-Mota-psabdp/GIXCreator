SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create VIEW [dbo].[vwAlteraBLDraftBody_Sel]
AS
Select 
	[ID_ADBB],
	[HblNo],
	[ShipperExporter],
	[Consignee],
	[NotifyParty],
	[ExportReferencesFatura],
	[ExportreferencesBooking],
	[ForwardingAgentReferences],
	[PlaceOfReceipt],
	[Vessel],
	[Voyage],
	[PortOfLoading],
	[PierTerminal],
	[PortOfDischarge],
	[ForTransShipmentTo],
	[PalceOfDelivery],
	[EmissaoBl],
	[FreteBl],
	[Bl],
	[SystemCode], 
	[dt_ins],
	[dt_atualizacao_bl],
	[Nome_Excel_Lido]
	,[Message]
from 
ATL_INT.dbo.AlteraBLDraftBody with(nolock)	



GO
